defmodule NotifierWeb.RoomChannelTest do
  use ExUnit.Case

  use ExUnitProperties

  describe "#join" do
    property "should call join succesfully" do
      socket = :socket
      assert NotifierWeb.RoomChannel.join("room:any", %{}, socket) == {:ok, socket}
    end
  end

  describe "#handle_in" do
    property "should call handle_in for ping succesfully" do
      socket = :socket
      assert NotifierWeb.RoomChannel.handle_in("ping", %{}, socket) == {:reply, {:ok, %{}}, socket}
    end
  end
end
