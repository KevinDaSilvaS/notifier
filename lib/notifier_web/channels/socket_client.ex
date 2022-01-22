defmodule SocketClient do

  use Slipstream,
    restart: :permanent

  require Logger

  def connect(config) do
    await_connect connect!(config)
  end

  def join_topic(socket, topic) do
    await_join join(socket, topic), topic
  end

  def push(socket, topic, payload) do
    push(socket, topic, "shout", payload)
  end

  @impl Slipstream
  def handle_continue(:finish, socket), do: {:noreply, socket}

  @impl Slipstream
  def handle_connect(socket), do: {:ok, socket}

  @impl Slipstream
  def handle_join(_topic, _join_response, socket), do: {:ok, socket}

  @impl Slipstream
  def handle_reply(_ref, _metrics, socket), do: {:ok, socket}

  @impl Slipstream
  def handle_message(_topic, _event, _message, socket), do: {:ok, socket}

  @impl Slipstream
  def handle_disconnect(_reason, socket), do: reconnect(socket)
end
