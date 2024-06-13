defmodule VachanWeb.CampaignBuilderLive do
  use VachanWeb, :live_view

  @modals [
    :list_selector,
    :contact_list_creator,
    :sender_profile_selector,
    :sender_profile_creator
  ]
  @impl true
  def mount(_params, _sessions, socket) do
    {:ok,
     socket
     |> assign(:campaign, nil)
     |> assign(:modal, nil)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info({VachanWeb.CampaignBuilder.ContentComponent, {:content, content}}, socket) do
    {:noreply, socket |> assign(:content, content)}
  end

  @impl true
  def handle_event("select_list", %{"list_id" => list_id}, socket) do
    contact_list =
      socket.assigns.contact_lists |> Enum.find(fn x -> x.id == list_id end)

    socket.assigns.campaign
    |> Vachan.Massmail.Campaign.associate_contact_list!(contact_list.id, ash_opts(socket))

    {:noreply,
     socket
     |> assign(:modal, nil)
     |> assign(:contact_list, contact_list)}
  end

  @impl true
  def handle_event("select_sender_profile", %{"sender_profile_id" => sender_profile_id}, socket) do
    sender_profile =
      socket.assigns.sender_profiles |> Enum.find(fn x -> x.id == sender_profile_id end)

    socket.assigns.campaign
    |> Vachan.Massmail.Campaign.associate_sender_profile!(sender_profile.id, ash_opts(socket))

    {:noreply,
     socket
     |> assign(:modal, nil)
     |> assign(:sender_profile, sender_profile)}
  end

  @impl true
  def handle_event("show_modal", %{"modal" => modal}, socket) do
    modal = String.to_existing_atom(modal)
    {:noreply, socket |> assign(:modal, modal)}
  end

  defp apply_action(socket, _live_action, %{"id" => campaign_id} = _params) do
    campaign = get_campaign(socket, campaign_id)

    contact_list =
      campaign.contact_list
      |> Ash.load!(:people_count, ash_opts(socket))

    socket
    |> assign(:campaign, campaign)
    |> assign(:campaign_id, campaign_id)
    |> assign(:content, campaign.content)
    |> assign(:contact_list, contact_list)
    |> assign(:contact_lists, get_contact_lists(socket))
    |> assign(:sender_profile, campaign.sender_profile)
    |> assign(:sender_profiles, get_sender_profiles(socket))
  end

  defp get_campaign(socket, campaign_id) do
    Vachan.Massmail.Campaign.get_by_id!(campaign_id, ash_opts(socket))
    |> Ash.load!(:sender_profile, ash_opts(socket))
    |> Ash.load!(:content, ash_opts(socket))
    |> Ash.load!(:contact_list, ash_opts(socket))
  end

  defp get_contact_lists(socket) do
    Vachan.Crm.List.read_all!(ash_opts(socket))
    |> Ash.load!(:people_count, ash_opts(socket))
  end

  defp get_sender_profiles(socket) do
    Vachan.SenderProfiles.SenderProfile.read_all!(ash_opts(socket))
  end

  defp get_people_count(socket) do
    Vachan.Crm.Person |> Ash.count!(ash_opts(socket))
  end
end
