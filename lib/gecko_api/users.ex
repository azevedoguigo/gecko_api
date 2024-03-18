defmodule GeckoApi.Users do
  @moduledoc """
  This module provides function delegations to create, get, and update user data.
  """
  alias GeckoApi.Users.{Create, Get}

  defdelegate create_user(params), to: Create, as: :call
  defdelegate get_user(user_id), to: Get, as: :call
end
