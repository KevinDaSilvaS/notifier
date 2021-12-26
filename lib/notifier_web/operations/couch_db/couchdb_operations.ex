defmodule NotifierWeb.CouchDb.Operations do

  import NotifierWeb.HTTPClient, only: [ post: 2 ]
  @couchdb_url "http://admin:password@172.17.0.2:5984/"
  @db_name "notifications/"
  def get_notifications_operation(user_id, limit, page) do

    url = @couchdb_url <> @db_name <> "_find"
    body = %{
      "selector" => %{
        "user_id" => user_id
      },
      "fields"=> ["_id", "date", "message", "title"],
      "sort" => [%{"date" => "desc"}],
      "limit" => limit,
      "skip"=> page-1,
      "execution_stats" => false
    }

    {:ok, res} = post url, body
    body = Jason.decode! res.body

    case body["error"] do
      nil -> {:ok, body["docs"]}
      _ -> {:error, body["error"]}
    end
  end

  #insert_notification_operation(%{
    #"date" => "2021-12-27",
    #"message" => "Task via api",
    #"title" => "Api",
    #"user_id" => "123456"
  #})
  def insert_notification_operation(notification) do
    url = @couchdb_url <> @db_name
    {:ok, res} = post url, notification
    {:created, Jason.decode!(res.body)}
  end
end
