defmodule GeckoApi.Users do
  @moduledoc """
  This module provides function delegations to create, get, and update user data.
  """

  alias GeckoApi.Users.Create

  defdelegate create_user(params), to: Create, as: :call
end
