defmodule VachanWeb.SenderProfileLive.Index do
  use VachanWeb, :live_view

  alias Vachan.SenderProfiles.SenderProfile

  @impl true
  def mount(params, session, socket) do
    {:ok,
     socket
     |> stream(:sender_profiles, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Sender Profile")
    |> assign(:sender_profile, SenderProfile.get_by_id!(id, ash_opts(socket)))
  end

  defp apply_action(socket, :index, _params) do
    sender_profiles = SenderProfile.read_all!(ash_opts(socket))

    socket
    |> stream(:sender_profiles, sender_profiles)
    |> assign(:sender_profile, nil)
    |> assign(:page_title, "Sender Profiles")
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Sender Profile")
    |> assign(:sender_profile, %SenderProfile{})
  end
end
