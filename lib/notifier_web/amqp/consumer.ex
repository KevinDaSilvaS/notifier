defmodule Consumer do
  use GenServer
  use AMQP, restart: :permanent
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  @exchange    "notifier"
  @queue       "notifications"
  @queue_error "#{@queue}_error"

  def init(_opts) do
    {:ok, conn} = Connection.open("amqp://guest:guest@172.17.0.3")
    {:ok, chan} = Channel.open(conn)
    setup_queue(chan)

    # Limit unacknowledged messages to 10
    :ok = Basic.qos(chan, prefetch_count: 10)
    # Register the GenServer process as a consumer
    {:ok, _consumer_tag} = Basic.consume(chan, @queue)
    {:ok, chan}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    # You might want to run payload consumption in separate Tasks in production
    consume(chan, tag, redelivered, payload)
    {:noreply, chan}
  end

  def handle_info(_, chan) do
    {:noreply, chan}
  end

  defp setup_queue(chan) do
    {:ok, _} = Queue.declare(chan, @queue_error, durable: true)
    # Messages that cannot be delivered to any consumer in the main queue will be routed to the error queue
    {:ok, _} = Queue.declare(chan, @queue,
                             durable: true,
                             arguments: [
                               {"x-dead-letter-exchange", :longstr, ""},
                               {"x-dead-letter-routing-key", :longstr, @queue_error}
                             ]
                            )
    :ok = Exchange.topic(chan, @exchange, durable: true)
    :ok = Queue.bind(chan, @queue, @exchange)
  end

  defp consume(channel, tag, _redelivered, payload) do
    socket = Agent.SocketState.get_socket_state()
    case socket do
      {:ok, socket} ->
        Logger.info "Message received: #{inspect(payload)}"
        {:ok, parsed_payload} = Jason.decode payload
        topic = "room:" <> parsed_payload["user_id"]

        {:ok, joined} = SocketClient.join_topic socket, topic
        SocketClient.push joined, topic, parsed_payload
        :ok = Basic.ack channel, tag
      _ ->
        Logger.error "Notifier is not up yet"
    end
  end
end
