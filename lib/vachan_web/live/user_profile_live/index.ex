defmodule VachanWeb.UserProfileLive.Index do
  use VachanWeb, :live_view

  alias Vachan.Accounts
  alias Vachan.Accounts.User
  alias Vachan.Repo

  @impl true
  def mount(_params, %{"user" => query} = _session, socket) do
    user_id = extract_user_id(query)

    case Repo.get(User, user_id) do
      nil ->
        {:ok, assign(socket, :user, nil)}
      user ->
        {:ok, assign(socket, :user, user)}
    end
  end

  defp extract_user_id("user?id=" <> id), do: id
  defp extract_user_id(_), do: nil
end
