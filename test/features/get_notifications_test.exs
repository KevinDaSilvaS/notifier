defmodule NotifierWeb.GetNotificationsTest do
  use ExUnit.Case

  use ExUnitProperties

  describe "#[GET] get notifications" do

    property "should get a list of notifications" do
      insert_register()
      insert_register()
      {:ok, data} = HTTPoison.get "http://127.0.0.1:4000/api/notifications/user_id"
      body = Jason.decode! data.body
      assert body["code"] == 200
      assert length(body["details"]) > 0
    end

    property "should get a list of notifications with limit set" do
      {:ok, data} = HTTPoison.get "http://127.0.0.1:4000/api/notifications/user_id?limit=1"
      body = Jason.decode! data.body
      assert body["code"] == 200
      assert length(body["details"]) == 1
    end

    property "should get a list of notifications with page and limit set" do
      {:ok, data_page1} = HTTPoison.get "http://127.0.0.1:4000/api/notifications/user_id?page=1&limit=3"
      {:ok, data_page2} = HTTPoison.get "http://127.0.0.1:4000/api/notifications/user_id?page=2&limit=3"

      body_page1 = Jason.decode! data_page1.body
      body_page2 = Jason.decode! data_page2.body

      assert body_page1["code"] == 200
      assert body_page2["code"] == 200
      assert length(body_page1["details"]) >= length(body_page2["details"])

      page1__ids = Enum.map(body_page1["details"], &(&1["_id"]))
      page2__ids = Enum.map(body_page2["details"], &(&1["_id"]))

      assert page1__ids != page2__ids
    end
  end

  def insert_register do
    notification = %{
      "message" => "msg",
      "title"   => "ttl",
      "user_id" => "user_id"
    }
    NotifierWeb.CouchDb.Operations.insert_notification_operation(notification)
  end
end
