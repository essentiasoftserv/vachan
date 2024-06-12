defmodule VachanWeb.CampaignBuilderLive do
  use VachanWeb, :live_view

  @stages [
    nil,
    :content_edit,
    :add_new_contacts,
    :choose_list,
    :choose_contacts,
    :choose_credentials,
    :add_credentials
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

  defp apply_action(socket, _live_action, %{"id" => campaign_id} = _params) do
    campaign = get_campaign(socket, campaign_id)

    socket
    |> assign(:campaign, campaign)
    |> assign(:campaign_id, campaign_id)
    |> assign(:content, campaign.content)
    |> assign(:contact_list, campaign.contact_list)
    |> assign(:sender_profile, campaign.sender_profile)
  end

  defp get_campaign(socket, campaign_id) do
    Vachan.Massmail.Campaign.get_by_id!(campaign_id, ash_opts(socket))
    |> Ash.load!(:sender_profile, ash_opts(socket))
    |> Ash.load!(:content, ash_opts(socket))
    |> Ash.load!(:contact_list, ash_opts(socket))
  end
end
