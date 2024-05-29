defmodule VachanWeb.SenderProfileLive.Index do
  use VachanWeb, :live_view

  alias Vachan.SenderProfiles.SenderProfile

  @impl true
  def mount(_params, _session, socket) do
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

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    sender_profiles = search_people_by_sender_profile_name(query, socket)
    if String.trim(query) == "" do
      {:noreply, assign(socket, sender_profiles: sender_profiles)}
    else
      {:noreply, stream(socket, :sender_profiles, sender_profiles, reset: true)}
    end
  end

  defp search_people_by_sender_profile_name(query, socket) when is_binary(query) do
    {:ok, sender_profiles} = SenderProfile.read_all(ash_opts(socket))
    capitalized_query = String.capitalize(query)
    Enum.filter(sender_profiles, fn sender_profile ->
      String.contains?(String.capitalize(sender_profile.title), capitalized_query)
    end)
  end
end
