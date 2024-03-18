defmodule GeckoApiWeb.ErrorJSON do
  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def error(%{error_data: %{status_code: :not_found} = error_data}) do
    %{
      status: 404,
      message: error_data.message
    }
  end

  def error(%{error_data: %{status_code: :bad_request} = error_data}) do
    %{
      status: 400,
      message: error_data.message
    }
  end

  def error(%{changeset: %Ecto.Changeset{} = changeset}) do
    %{errors: Ecto.Changeset.traverse_errors(changeset, &translate_errors/1)}
  end

  defp translate_errors({msg, opts}) do
    Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
      opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
    end)
  end
end
