defmodule VachanWeb.Plugs.RedirectIfAuthenticated do
  import Plug.Conn
  import Phoenix.Controller
  alias VachanWeb.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, _default) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: Routes.person_path(conn, :index))
      |> halt()
    else
      conn
    end
  end
end
