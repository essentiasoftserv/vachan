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
end
