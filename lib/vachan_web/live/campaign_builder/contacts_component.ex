defmodule VachanWeb.CampaignBuilder.ContactsComponent do
  # alias Postgrex.Extensions.Array
  use VachanWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= if @contact_list != nil do %>
        <p>remove association</p>
      <% else %>
        <.button phx-click={JS.push("set_mode", value: %{mode: :choose_list})} phx-target={@myself}>
          Choose list
        </.button>
        <.button phx-click={JS.push("set_mode", value: %{mode: :new_list})} phx-target={@myself}>
          Add Contacts
        </.button>
      <% end %>

      <.modal
        :if={@mode == :choose_list}
        id="choose-list"
        show
        phx-target={@myself}
        on_cancel={JS.push("set_mode", value: %{mode: :show})}
      >
        choose list modal
      </.modal>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:mode, :show)
     |> assign(:parsed_data, [])
     |> assign(:headers, [])}
  end

  defp csv_to_array(blob) do
    blob
    |> String.trim()
    |> String.split("\n")
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn line ->
      String.split(line, ",")
      |> Stream.map(&String.trim/1)
      |> Enum.to_list()
    end)
    |> Enum.to_list()
  end

  @impl true
  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    [headers | parsed_data] = csv_to_array(params["blob"])

    {:noreply,
     socket
     |> assign(:form, to_form(form))
     |> assign(:parsed_data, parsed_data)
     |> assign(:headers, headers)}
  end

  @impl true
  def handle_event("save", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)

    case AshPhoenix.Form.submit(form) do
      {:ok, recepients} ->
        notify_parent({:recepients, recepients})

        {
          :noreply,
          socket
          |> put_flash(:info, "Recepients Saved")
        }

      {:error, form} ->
        IO.inspect(form)
        {:noreply, assign(socket, form: to_form(form))}
    end
  end

  def handle_event("set_mode", %{"mode" => mode}, socket) do
    {:noreply, socket |> assign(:mode, String.to_existing_atom(mode))}
  end

  @impl true
  def handle_event("choose-list", _params, socket) do
    {:noreply, socket |> assign(:mode, :choose_list)}
  end

  @impl true
  def handle_event("new-list", _params, socket) do
    {:noreply, socket |> assign(:mode, :new_list)}
  end

  defp create_form(assigns) do
    case assigns.recepients do
      nil ->
        Vachan.Massmail.Recepients
        |> AshPhoenix.Form.for_create(
          :create,
          ash_opts(assigns, domain: Vachan.Massmail)
        )
        |> to_form()

      recepients ->
        recepients
        |> AshPhoenix.Form.for_update(
          :update,
          ash_opts(assigns, domain: Vachan.Massmail)
        )
        |> to_form()
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
