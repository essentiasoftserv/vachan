defmodule VachanWeb.CampaignLive.Index do
  use VachanWeb, :live_view

  alias Vachan.Massmail.Campaign
  # alias Vachan.Crm.List

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:campaigns, Campaign.read_all!())}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    campaigns = search_campaign_name(query)
    {:noreply, stream(socket, :campaigns, campaigns, reset: true)}
  end

  defp search_campaign_name(query) when is_binary(query) do
    {:ok, campaigns} = Campaign.read_all()
    capitalized_query = String.capitalize(query)

    matching_campaigns_data =
      Enum.filter(campaigns, fn campaign ->
        String.contains?(String.capitalize(campaign.name), capitalized_query)
      end)
  end
end
