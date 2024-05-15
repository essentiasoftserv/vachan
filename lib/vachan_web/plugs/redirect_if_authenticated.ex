defmodule VachanWeb.Plugs.RedirectIfAuthenticated do
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: "/people")
      |> halt()
    else
      conn
    end
  end
end