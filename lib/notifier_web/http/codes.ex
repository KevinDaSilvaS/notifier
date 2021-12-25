defmodule NotifierWeb.Codes do
  def ok, do: 200

  def created, do: 201

  def bad_request, do: 400

  def internal_server_error, do: 500
end
