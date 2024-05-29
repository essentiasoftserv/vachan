defmodule VachanWeb.CampaignWizard.CampaignWizardLive do
  use VachanWeb, :live_view

  @doc """
  Multi step wizard for creation of a campaign.
  - step 1: create campaign content |> plain text vs mjml.
  - step 2: select people to send it to |> add people if none exist.
  - step 3: select the credentials to use to do it. |> add if none exist.
  - step 4: schedule / send.
  - step 5: view status updates.

  There shall be separate components for every step of the process.
  """

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:campaign, nil)
     |> assign(:campaign_id, nil)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info({_sender, {:message, object}}, socket) do
    {:noreply, socket}
  end

  defp wizard_steps do
    [
      %{
        live_action: :new,
        module: VachanWeb.CampaignWizard.NewCampaign,
        next: fn campaign_id -> "/wizard/#{campaign_id}/add-content/" end
      },
      %{
        live_action: :add_content,
        module: VachanWeb.CampaignWizard.ContentStep,
        next: fn campaign_id -> "/wizard/#{campaign_id}/add-recepients/" end
      },
      %{
        live_action: :add_recepients,
        module: VachanWeb.CampaignWizard.AddRecepients,
        next: fn campaign_id -> "/wizard/#{campaign_id}/add-sender-profile/" end
      },
      %{
        live_action: :add_sender_profile,
        module: VachanWeb.CampaignWizard.AddSenderProfile,
        next: fn campaign_id -> "/wizard/#{campaign_id}/review/" end
      },
      %{
        live_action: :review,
        module: VachanWeb.CampaignWizard.Review,
        next: fn campaign_id -> "/campaigns/#{campaign_id}/show/" end
      }
    ]
  end

  defp apply_action(socket, :new, _params) do
    socket |> assign(:current_step, get_current_step(:new))
  end

  defp apply_action(socket, live_action, %{"id" => campaign_id} = _params) do
    socket
    |> assign(:current_step, get_current_step(live_action))
    |> assign(:campaign, get_campaign(socket, campaign_id))
    |> assign(:campaign_id, campaign_id)
  end

  defp get_current_step(live_action) do
    wizard_steps()
    |> Enum.filter(fn x -> x.live_action == live_action end)
    |> hd
  end

  defp get_campaign(socket, campaign_id) do
    Vachan.Massmail.Campaign.get_by_id!(campaign_id, ash_opts(socket))
    |> Vachan.Massmail.load!(:sender_profile, ash_opts(socket))
    |> Vachan.Massmail.load!(:content, ash_opts(socket))
    |> Vachan.Massmail.load!(:recepients, ash_opts(socket))
  end
end
