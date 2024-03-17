defmodule GeckoApiWeb.FallbackController do
  use GeckoApiWeb, :controller

  alias Ecto.Changeset

  def call(conn, {:error, %Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: GeckoApiWeb.ErrorJSON)
    |> render(:error, changeset: changeset)
  end
end
