defmodule NotifierWeb.Response do
  def response({:error, err}), do: %{ code: 400, details: err }
  def response({:ok, data}), do: %{ code: 200, details: data }
  def response({:created, data}), do: %{ code: 201, details: data }
end
