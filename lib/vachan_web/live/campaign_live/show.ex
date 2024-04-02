defmodule VachanWeb.CampaignLive.Show do
  alias Vachan.Massmail
  use VachanWeb, :live_view

  alias Vachan.Massmail.Campaign
  alias Vachan.Massmail.Message

  def render(assigns) do
    ~H"""
    <div>
      <.list>
        <:actions>
          <.link patch={~p"/campaigns/#{@campaign}/edit"} phx-click={JS.push_focus()}>
            <.button>Edit campaign</.button>
          </.link>
        </:actions>
        <:item title="Campaign Name"><%= @campaign.name %></:item>
        <:item title="Email Subject"><%= @campaign.subject %></:item>
        <:item title="list"><%= @campaign.list %></:item>
      </.list>
      <.back navigate={~p"/campaigns"}>
        <.button>Back to campaigns</.button>
      </.back>
    </div>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    campaign = Campaign.get_by_id!(id)
    IO.inspect(Massmail.load(campaign, :list))

    # Message.read_all_for_campaign!(campaign)
    messages = []

    {:ok,
     socket
     |> assign(campaign: campaign)
     |> assign(messages: messages)}
  end
end
