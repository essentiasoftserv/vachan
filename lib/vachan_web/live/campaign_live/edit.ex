defmodule VachanWeb.CampaignLive.Edit do
  use VachanWeb, :live_view

  alias Vachan.Massmail.Campaign
  alias Vachan.Crm.List
  alias Vachan.SenderProfiles.SenderProfile

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    campaign = Campaign.get_by_id!(id, ash_opts(socket))

    {:ok,
     socket
     |> assign(campaign: campaign)
     |> assign(list_options: list_options(socket))
     |> assign(sender_profile_options: sender_profile_options(socket))
     |> assign(patch: ~p"/campaigns")
     |> assign(form: update_form(socket, campaign))}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(patch: ~p"/campaigns")
     |> assign(list_options: list_options(socket))
     |> assign(sender_profile_options: sender_profile_options(socket))
     |> assign(form: create_form(socket))}
  end

  @impl true
  def handle_event("validate", %{"form" => campaign_params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, campaign_params)
    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("save", %{"form" => campaign_params}, socket) do
    save_campaign(socket, socket.assigns.live_action, campaign_params)
  end

  defp create_form(socket) do
    Campaign
    |> AshPhoenix.Form.for_create(:create, ash_opts(socket, api: Vachan.Massmail))
    |> to_form()
  end

  defp update_form(socket, campaign) do
    campaign
    |> AshPhoenix.Form.for_update(:update, ash_opts(socket, api: Vachan.Massmail))
    |> to_form()
  end

  defp list_options(socket) do
    List.read_all!(ash_opts(socket))
    |> Enum.map(&{&1.name, &1.id})
  end

  defp sender_profile_options(socket) do
    SenderProfile.read_all!(ash_opts(socket))
    |> Enum.map(&{&1.name, &1.id})
  end

  defp save_campaign(socket, :edit, campaign_params) do
    form = AshPhoenix.Form.validate(socket.assigns.form, campaign_params)

    case AshPhoenix.Form.submit(form) do
      {:ok, campaign} ->
        notify_parent({:saved, campaign})

        {:noreply,
         socket
         |> put_flash(:info, "campaign updated successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp save_campaign(socket, :new, campaign_params) do
    form = AshPhoenix.Form.validate(socket.assigns.form, campaign_params)

    case AshPhoenix.Form.submit(form) do
      {:ok, campaign} ->
        notify_parent({:saved, campaign})

        {:noreply,
         socket
         |> put_flash(:info, "campaign created successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
