defmodule VachanWeb.CampaignWizard.AddSenderProfile do
  use VachanWeb, :live_component

  alias Vachan.SenderProfiles.SenderProfile

  @doc """
  If there are any existing sender profiles configured allow choosing one.
  if not, allow, allow creating and associating one with the campagin.
  """

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Choose a Sender Profile
        <:subtitle>
          Or <.link patch={~p"/wizard/#{@campaign.id}/add-sender-profile/create"}> create one </.link>
        </:subtitle>
      </.header>
      <.table id="sender_profiles" rows={@sender_profiles}>
        <:col :let={profile} label="Profile's Name"><%= profile.title %></:col>
        <:col :let={profile} label="Profile's Name"><%= profile.name %></:col>
        <:action :let={profile}>
          <.button
            phx-target={@myself}
            phx-click={
              JS.push("add_sender_profile",
                value: %{sender_profile_id: profile.id, campaign_id: @campaign.id}
              )
            }
          >
            Select
          </.button>
        </:action>
      </.table>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:sender_profile, nil)
     |> assign(:sender_profiles, sender_profiles(assigns))
     |> assign(:form, create_form(assigns))}
  end

  @impl true
  def handle_event(
        "add_sender_profile",
        %{"sender_profile_id" => sender_profile_id, "campaign_id" => campaign_id},
        socket
      ) do
    Vachan.Massmail.Campaign.get_by_id!(campaign_id, ash_opts(socket.assigns))
    |> Vachan.Massmail.Campaign.add_sender_profile(sender_profile_id, ash_opts(socket.assigns))

    {:noreply,
     socket
     |> put_flash(:info, "Selected sender profile associated")
     |> push_patch(to: ~p"/wizard/#{socket.assigns.campaign.id}/review")}
  end

  @impl true
  def handle_event("validiate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    {:noreply, socket |> assign(:form, to_form(form))}
  end

  @impl true
  def handle_event("save", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)

    case AshPhoenix.Form.submit(form) do
      {:ok, content} ->
        # notify_parent({:success, content})

        {
          :noreply,
          socket
          |> put_flash(:info, "Content Saved")
          |> push_patch(to: socket.assigns.next_f.(socket.assigns.campaign.id))
        }

      {:error, form} ->
        IO.inspect(form)

        {:noreply, assign(socket, form: to_form(form))}
    end
  end

  defp sender_profiles(assigns) do
    SenderProfile.read_all!(ash_opts(assigns))
  end

  defp create_form(assigns) do
    Vachan.Massmail.Content
    |> AshPhoenix.Form.for_create(
      :create,
      ash_opts(assigns, api: Vachan.Massmail)
    )
    |> to_form()
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
