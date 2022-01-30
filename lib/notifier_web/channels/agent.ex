defmodule Agent.SocketState do

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
  def start_link(initial_state) do
    Agent.start_link fn -> initial_state end, name: :agent
  end

  def get_socket_state do
    state = Agent.get :agent, fn socket_state -> socket_state end
    case state do
      {:ok, _socket} -> state
      _ -> update_socket_state try_to_connect()
    end
  end

  def try_to_connect do
    try do
      SocketClient.connect([uri: "ws://127.0.0.1:4000/notifications/websocket"])
    rescue
      _ -> {:error}
    end
  end

  def update_socket_state(new_state) do
    Agent.update :agent, fn _socket_state -> new_state end
  end

end
