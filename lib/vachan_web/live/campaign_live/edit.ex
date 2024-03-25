defmodule VachanWeb.CampaignLive.Edit do
  use VachanWeb, :live_view

  alias Vachan.Massmail.Campaign
  alias Vachan.Massmail.Message

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    campaign = Campaign.get_by_id(id)

    {:ok,
     socket
     |> assign(campaign: campaign)
     |> assign(form: update_form(socket.assigns))}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(form: create_form(socket.assigns))}
  end

  defp create_form(assigns) do
    Campaign
    |> AshPhoenix.Form.for_create(:create, api: Campaign)
    |> to_form()
  end

  defp update_form(assigns) do
    assigns.campaign
    |> AshPhoenix.Form.for_update(:update, api: Campaign)
    |> to_form()
  end

  @impl true
  def handle_event("save", %{"campaign" => campaign_params}, socket) do
    case AshPhoenix.Form.save(campaign_params, api: Campaign) do
      {:ok, campaign} ->
        {:noreply, socket |> assign(campaign: campaign)}

      {:error, form} ->
        {:noreply, socket |> assign(form: form)}
    end
  end

  @impl true
  def handle_event("validate", %{"form" => campaign_params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, campaign_params)
    {:noreply, assign(socket, form: form)}
  end
end
