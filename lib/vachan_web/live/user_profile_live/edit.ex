defmodule VachanWeb.UserProfileLive.Edit do
  use VachanWeb, :live_view

  alias Vachan.Accounts
  alias Vachan.Accounts.User
  alias Vachan.Repo

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    case Repo.get(User, id) do
      nil ->
        {:ok, assign(socket, :user, nil)}
      user ->
        {:ok, assign(socket, :user, user)}
    end
  end


end
