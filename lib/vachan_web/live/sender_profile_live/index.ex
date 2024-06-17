defmodule VachanWeb.SenderProfileLive.Index do
  use VachanWeb, :live_view

  alias Vachan.SenderProfiles.SenderProfile
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> stream(:sender_profiles, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    IO.inspect(params, label: "Handle Params")
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id} = params) do
    sender_profile = SenderProfile.get_by_id!(id, ash_opts(socket))
    smtp_password = Map.get(params, "password")

    updated_sender_profile =
      if smtp_password != "" do
        hashed_password = hash_password(smtp_password)
        IO.inspect(hashed_password, label: "Hashed Password - Edit")
        %SenderProfile{sender_profile | password: hashed_password}
      else
        sender_profile
      end

    IO.inspect(updated_sender_profile, label: "Updated Sender Profile - Edit")

    socket
    |> assign(:page_title, "Edit Sender Profile")
    |> assign(:sender_profile, updated_sender_profile)
  end

  defp apply_action(socket, :index, _params) do
    sender_profiles = SenderProfile.read_all!(ash_opts(socket))
    IO.inspect(sender_profiles, label: "Sender Profiles - Index")
    socket
    |> stream(:sender_profiles, sender_profiles)
    |> assign(:sender_profile, nil)
    |> assign(:page_title, "Sender Profiles")
  end

  defp apply_action(socket, :new, params) do
    smtp_password = Map.get(params, "password")

    hashed_password = hash_password(smtp_password)
    IO.inspect(hashed_password, label: "Hashed Password - New")

    sender_profile = %SenderProfile{
      password: hashed_password
    }

    IO.inspect(sender_profile, label: "New Sender Profile")

    socket
    |> assign(:page_title, "New Sender Profile")
    |> assign(:sender_profile, sender_profile)
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    IO.inspect(query, label: "Search Query")
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

  defp hash_password(password) do
    IO.inspect(password, label: "Hashing Password")
    Bcrypt.hash_pwd_salt(password)
  end

  def verify_password(plain_password, hashed_password) do
    Bcrypt.verify_pass(plain_password, hashed_password)
  end
end
