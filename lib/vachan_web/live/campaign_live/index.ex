defmodule VachanWeb.CampaignLive.Index do
  use VachanWeb, :live_view

  alias Vachan.Massmail.Campaign
  # alias Vachan.Crm.List

  @impl true
  def mount(_params, _session, socket) do
    {:ok, campaigns} = Campaign.read_all(ash_opts(socket))
    {:ok, stream(socket, :campaigns, campaigns)}
  end

  def handle_event("run", %{"id" => id}, socket) do
    Oban.Job.new(%{campaign_id: id},
      queue: :enqueue_emails,
      worker: Vachan.Massmail.Workers.EnqueueEmails
    )
    |> Oban.insert!()

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    campaigns = search_campaign_name(query, socket)
    {:noreply, stream(socket, :campaigns, campaigns, reset: true)}
  end

  defp search_campaign_name(query, socket) when is_binary(query) do
    {:ok, campaigns} = Campaign.read_all(ash_opts(socket))
    capitalized_query = String.capitalize(query)
    Enum.filter(campaigns, fn campaign ->
      String.contains?(String.capitalize(campaign.name), capitalized_query)
    end)
  end
end
