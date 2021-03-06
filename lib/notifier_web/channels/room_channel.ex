defmodule NotifierWeb.RoomChannel do
  use NotifierWeb, :channel

  @impl true

  def join("room:" <> _user_id, _payload, socket) do
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", _payload, socket) do
    {:reply, :ok, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    NotifierWeb.CouchDb.Operations.insert_notification_operation(payload)
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end
end
