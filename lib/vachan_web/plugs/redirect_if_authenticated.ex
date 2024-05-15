def call(conn, _default) do
  IO.inspect(conn.assigns[:current_user], label: "Current User") # Check if current_user assign is set
  if conn.assigns[:current_user] do
    IO.puts("Redirecting authenticated user") # Debug statement to verify redirection
    conn
    |> redirect(to: "/people") # Hardcoded redirection for testing
    |> halt()
  else
    IO.puts("User not authenticated") # Debug statement if user is not authenticated
    conn
  end
end
