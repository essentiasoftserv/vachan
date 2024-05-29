defmodule VachanWeb.CampaignWizard.NewCampaign do
  use VachanWeb, :live_component
  alias Vachan.Massmail.Campaign

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center h-screen">
      <div>
        <.simple_form
          for={@form}
          phx-change="validate"
          phx-submit="save"
          phx-target={@myself}
          class="p-4"
        >
          <.input
            field={@form[:name]}
            type="text"
            label="Campaign Name"
            placeholder="What do you want to call your new campaign?"
          >
          </.input>

          <:actions>
            <.button phx-disable-with="Creating ... ">Create Campaign</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(form: create_form(assigns))}
  end

  @impl true
  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    {:noreply, assign(socket, form: to_form(form))}
  end

  @impl true
  def handle_event("save", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)

    case AshPhoenix.Form.submit(form) do
      {:ok, campaign} ->
        notify_parent({:campaign_created, campaign})
        # notify_parent({:success, campaign})

        {
          :noreply,
          socket
          |> put_flash(:info, "Campaign Created")
          |> push_patch(to: socket.assigns.next_f.(campaign.id))
        }

      {:error, form} ->
        IO.inspect(form)
        {:noreply, assign(socket, form: to_form(form))}
    end
  end

  defp create_form(assigns) do
    Campaign
    |> AshPhoenix.Form.for_create(:create, ash_opts(assigns, api: Vachan.Massmail))
    |> to_form()
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
