defmodule NotifierWeb.CodesTest do
  use ExUnit.Case

  use ExUnitProperties

  describe "#ok" do
    property "should return http code number" do
      assert NotifierWeb.Codes.ok() == 200
    end
  end

  describe "#created" do
    property "should return http code number" do
      assert NotifierWeb.Codes.created() == 201
    end
  end

  describe "#bad_request" do
    property "should return http code number" do
      assert NotifierWeb.Codes.bad_request() == 400
    end
  end

  describe "#internal_server_error" do
    property "should return http code number" do
      assert NotifierWeb.Codes.internal_server_error() == 500
    end
  end
end
