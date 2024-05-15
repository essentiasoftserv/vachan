defmodule VachanWeb.Plugs.RedirectIfAuthenticated do
  import Plug.Conn
  import Phoenix.Controller

  def init(_opts), do: nil

  def call(conn, _opts) do
    if is_authenticated(conn.assigns[:current_user]) do
      conn
      |> put_flash(:info, "You are already signed in.")
      |> redirect(to: "/people") # Redirect to the desired page
    else
      conn
    end
  end

  defp is_authenticated(nil), do: false
  defp is_authenticated(_user), do: true
end
