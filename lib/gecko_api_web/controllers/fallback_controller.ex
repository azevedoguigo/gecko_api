defmodule GeckoApiWeb.FallbackController do
  use GeckoApiWeb, :controller

  alias Ecto.Changeset

  def call(conn, {:error, %{status_code: :not_found} = error_data}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: GeckoApiWeb.ErrorJSON)
    |> render(:error, error_data: error_data)
  end

  def call(conn, {:error, %{status_code: :bad_request} = error_data}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: GeckoApiWeb.ErrorJSON)
    |> render(:error, error_data: error_data)
  end

  def call(conn, {:error, %Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: GeckoApiWeb.ErrorJSON)
    |> render(:error, changeset: changeset)
  end
end
