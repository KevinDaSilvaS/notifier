defmodule NotifierWeb.CouchDb.Operations do

  import NotifierWeb.HTTPClient, only: [ post: 2 ]
  @port     System.fetch_env! "COUCHDB_PORT"
  @username System.fetch_env! "COUCHDB_USER"
  @db_name  System.fetch_env! "COUCHDB_NAME"
  @password System.fetch_env! "COUCHDB_PASSWORD"
  @host     System.fetch_env! "COUCHDB_HOST"
  @couchdb_url "http://#{@username}:#{@password}@#{@host}:#{@port}/#{@db_name}/"

  def get_notifications_operation(user_id, limit, page) do

    url = @couchdb_url <> "_find"
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
    date = Date.utc_today() |> Date.to_string()
    notification_payload = Map.put(notification, :date, date)

    {:ok, res} = post @couchdb_url, notification_payload
    {:created, Jason.decode!(res.body)}
  end
end
