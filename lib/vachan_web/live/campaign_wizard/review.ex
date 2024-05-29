defmodule VachanWeb.CampaignWizard.Review do
  use VachanWeb, :live_component

  @doc """
  The last stage of the wizard, where all the details of the campaign are reviewed before hitting the send button.
  """

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= if @campaign do %>
        <div>
          <ul>
            <li><%= @campaign.id %></li>
            <li><%= @campaign.name %></li>
            <li><%= @campaign.recepients.id %></li>
            <li><%= @campaign.content.subject %></li>
            <li><%= @campaign.content.text_body %></li>
          </ul>
        </div>
        <div>
          <.button phx-click="send_mails">Send Mails</.button>
        </div>
      <% else %>
        hahahah
      <% end %>
    </div>
    """
  end
end
