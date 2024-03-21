defmodule GeckoApiWeb.AuthJSON do
  def login(%{token: token}) do
    %{
      data: token,
      status: 200
    }
  end
end
