defmodule NotifierWeb.Response do
  import NotifierWeb.Codes

  def response({:error, err}), do: %{ code: bad_request(), details: err }
  def response({:ok, data}), do: %{ code: ok(), details: data }
  def response({:created, data}), do: %{ code: created(), details: data }
  def response({_, data}), do: %{ code: internal_server_error(), details: data }
end
