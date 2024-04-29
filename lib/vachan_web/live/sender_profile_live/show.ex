defmodule VachanWeb.SenderProfileLive.Show do
  use VachanWeb, :live_view

  alias Vachan.SenderProfiles.SenderProfile

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:sender_profile, SenderProfile.get_by_id!(id, ash_opts(socket)))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:sender_profile, SenderProfile.get_by_id!(id, ash_opts(socket)))}
  end

  defp page_title(:show), do: "Show Person"
  defp page_title(:edit), do: "Edit Person"
end
