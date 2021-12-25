defmodule NotifierWeb.GetNotificationsController do
  use NotifierWeb, :controller
  import NotifierWeb.CouchDb.Operations, only: [get_notifications_operation: 3]
  import NotifierWeb.Response

  @limit 15
  @page 1
  def get_notifications(conn, opts) do
    limit = String.to_integer(opts["limit"]) || @limit
    page  = String.to_integer(opts["page"])  || @page

    res = get_notifications_operation(opts["user"], limit, page) |> response()
    conn |> put_status(res.code) |> json(res)
  end
end
