defmodule VachanWeb.Plugs.LoadUser do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = if user_id, do: Vachan.Accounts.get_user!(user_id), else: nil
    assign(conn, :current_user, user)
  end
end
