defmodule NotifierWeb.ResponseTest do
  use ExUnit.Case

  use ExUnitProperties

  describe "#response" do
    property "when response is called with {:error, _any}" do
      for err <- generate_input(100) do
        assert NotifierWeb.Response.response({:error, err}) == %{ code: 400, details: err }
      end
    end

    property "when response is called with {:ok, _any}" do
      for data <- generate_input(100) do
        assert NotifierWeb.Response.response({:ok, data}) == %{ code: 200, details: data }
      end
    end

    property "when response is called with {:created, _any}" do
      for data <- generate_input(100) do
        assert NotifierWeb.Response.response({:created, data}) == %{ code: 201, details: data }
      end
    end

    property "when response is called with {:_any, _any}" do
        for data <- generate_input(100) do
          assert NotifierWeb.Response.response({data, data}) == %{ code: 500, details: data }
        end
    end
  end

  def generate_input(amount) do
    input = StreamData.frequency([
      {1, StreamData.integer()},
      {1, StreamData.binary()},
      {1, StreamData.boolean()},
      {1, StreamData.string(:ascii)},
      {1, StreamData.atom(:alphanumeric)},
    ])
    Enum.take(input, amount)
  end
end
