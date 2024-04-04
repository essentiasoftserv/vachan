defmodule VachanWeb.CampaignLive.Show do
  use VachanWeb, :live_view

  alias Vachan.Massmail
  alias Vachan.Massmail.Campaign
  alias Vachan.Massmail.Message

  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Person <%= @campaign.name %>
        <:subtitle>This is a campaign record from your database.</:subtitle>
        <:actions>
          <.link patch={~p"/campaigns/#{@campaign}/edit"} phx-click={JS.push_focus()}>
            <.button>Edit campaign</.button>
          </.link>
        </:actions>
      </.header>
      <.list>
        <:item title="Campaign Name"><%= @campaign.name %></:item>
        <:item title="Email Subject"><%= @campaign.subject %></:item>
        <:item title="list"><%= @campaign.list.name %></:item>
      </.list>
      <.back navigate={~p"/campaigns"}>
        <.button>Back to campaigns</.button>
      </.back>
    </div>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    campaign = Campaign.get_by_id!(id) |> Massmail.load!(:list)
    messages = []

    {:ok,
     socket
     |> assign(campaign: campaign)
     |> assign(messages: messages)}
  end
end
