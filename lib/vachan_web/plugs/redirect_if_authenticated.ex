defmodule VachanWeb.Plugs.RedirectIfAuthenticated do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(_opts), do: nil

  def call(conn, _) do
    if is_authenticated(conn) do
      conn
      |> put_flash(:info, "You are already signed in.")
      |> redirect(to: "/verify-email") # Redirect to the desired page
      |> halt()
    else
      conn
    end
  end

  defp is_authenticated(conn) do
    # Implement your logic to check if the user is authenticated here
    # For example, you can check if a user is present in the session
    user_id = get_session(conn, :user_id)
    !is_nil(user_id)
  end
end
