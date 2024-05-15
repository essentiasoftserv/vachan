defmodule VachanWeb.Plugs.LoadUser do
  import Plug.Conn

  alias Vachan.Accounts

  def init(default), do: default

  def call(conn, _default) do
    user_id = get_session(conn, :user_id)

    if user = user_id && Accounts.get_user(user_id) do
      assign(conn, :current_user, user)
    else
      conn
    end
  end
end
