defmodule VachanWeb.CampaignLive.Index do
  use VachanWeb, :live_view

  alias Vachan.Massmail.Campaign
  # alias Vachan.Crm.List

  @impl true
  def mount(_params, _session, socket) do
    Campaign.read_all!(ash_opts(socket))

    {:ok,
     socket
     |> assign(:pages, 0)
     |> assign(:active_page, 1)
     |> assign(:page_offset, 0)
     |> assign(:page_limit, 50)
     |> stream(:campaigns, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> maybe_assign(:active_page, page(params["page"]))
      |> maybe_assign(:page_offset, page_offset(page(params["page"]), socket.assigns.page_limit))

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    page = list_campaigns(socket)

    socket
    |> stream(:campaigns, page.results, reset: true)
    |> assign(:pages, ceil(page.count / socket.assigns.page_limit))
  end

  defp list_campaigns(socket) do
    page_count = [limit: socket.assigns.page_limit, offset: socket.assigns.page_offset]
    Campaign.list!(ash_opts(socket, page: page_count))
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    campaigns = search_campaign_name(query, socket)
    {:noreply, stream(socket, :campaigns, campaigns, reset: true)}
    campaigns = search_campaign_name(query, socket)
    {:noreply, stream(socket, :campaigns, campaigns, reset: true)}
  end

  defp search_campaign_name(query, socket) when is_binary(query) do
    {:ok, campaigns} = Campaign.read_all(ash_opts(socket))
    capitalized_query = String.capitalize(query)

    Enum.filter(campaigns, fn campaign ->
      String.contains?(String.capitalize(campaign.name), capitalized_query)
    end)
    Enum.filter(campaigns, fn campaign ->
      String.contains?(String.capitalize(campaign.name), capitalized_query)
    end)
  end

  defp page(nil), do: nil

  defp page(page_param) do
    {active_page, _} = Integer.parse(page_param)
    active_page
  end

  defp page_offset(nil, _page_limit), do: nil

  defp page_offset(page_param, page_limit) do
    (page_param - 1) * page_limit
  end

  defp maybe_assign(socket, _key, nil), do: socket
  defp maybe_assign(socket, key, val), do: socket |> assign(key, val)

  def active_class(on_page, active_page) when on_page == active_page, do: "active"
  def active_class(_on_page, _active_page), do: ""
end
