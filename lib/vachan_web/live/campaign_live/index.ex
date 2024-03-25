defmodule VachanWeb.CampaignLive.Index do
  use VachanWeb, :live_view

  alias Vachan.Crm.Campaign
  alias Vachan.Crm.List

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
