defmodule VachanWeb.CampaignLive.Index do
  use VachanWeb, :live_view

  alias Vachan.Massmail.Campaign
  # alias Vachan.Crm.List

  @page_limit 10

  @impl true
  def mount(_params, _session, socket) do
    {:ok, campaigns} = Campaign.read_all()

    total_count = length(campaigns)
    initial_page = get_page(campaigns, 1)

    {:ok,
     assign(socket,
       campaigns: Campaign.read_all!(),
       total_count: total_count,
       page_limit: @page_limit,
       current_page: 1
     )
     |> stream(:current_page_campaigns, initial_page)}
  end

  def handle_event("next_page", _params, socket) do
    %{current_page: current_page, total_count: total_count, page_limit: page_limit} =
      socket.assigns

    new_page = min(current_page + 1, div(total_count, page_limit) + 1)
    new_page_campaign = get_page(socket.assigns.campaigns, new_page)

    {:noreply,
     assign(socket, current_page: new_page)
     |> stream(:current_page_campaigns, new_page_campaign, reset: true)}
  end

  def handle_event("prev_page", _params, socket) do
    %{current_page: current_page} = socket.assigns
    new_page = max(current_page - 1, 1)
    new_page_campaign = get_page(socket.assigns.campaigns, new_page)

    {:noreply,
     assign(socket, current_page: new_page)
     |> stream(:current_page_campaigns, new_page_campaign, reset: true)}
  end

  defp get_page(campaigns, page) do
    Enum.slice(campaigns, ((page - 1) * @page_limit)..(page * @page_limit))
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    campaigns = search_campaign_name(query)
    {:noreply, stream(socket, :current_page_campaigns, campaigns, reset: true)}
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
