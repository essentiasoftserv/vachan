defmodule VachanWeb.DashLive do
  use VachanWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <h1>Welcome to Vachan!</h1>
      <p>
        This is the dashboard for Vachan. You can use this dashboard to manage your Vachan account.
      </p>
    </div>
    """
  end

  def mount(params, session, socket) do
    {:ok, socket}
  end
end
