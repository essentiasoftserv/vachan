defmodule VachanWeb.CampaignWizard.AddRecepients do
  # alias Postgrex.Extensions.Array
  use VachanWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} phx-change="validate" phx-submit="save" phx-target={@myself}>
        <.input
          label="Recepients csv"
          placeholder="email, first_name, last_name\n james@mi5.gov.uk, James, Bond"
          field={@form[:blob]}
          type="textarea"
        >
        </.input>
        <.input field={@form[:campaign_id]} type="hidden" value={@campaign.id}></.input>

        <:actions>
          <.button phx-disable-with="Saving ... ">Save content</.button>
        </:actions>
      </.simple_form>

      <div>
        <span>Preview</span>
        <span>Number of recepients: <%= length(@parsed_data) %></span>
        <table class="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400">
          <thead class="text-xs text-gray-700 uppercase bg-customBackground_header dark:bg-gray-700 dark:text-gray-400">
            <tr>
              <%= for header <- @headers do %>
                <th class="px-6 py-3"><%= header %></th>
              <% end %>
            </tr>
          </thead>
          <tbody>
            <%= for line <- @parsed_data do %>
              <tr class="bg-customBackground border-b dark:bg-gray-800 border-zinc-200 text-black dark:border-gray-700 hover:bg-customBackground_hover dark:hover:bg-gray-600">
                <%= for item <- line do %>
                  <td class="relative px-8 py-2"><%= item %></td>
                <% end %>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, create_form(assigns))
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
          |> push_patch(to: socket.assigns.next_f.(socket.assigns.campaign.id))
        }

      {:error, form} ->
        IO.inspect(form)
        {:noreply, assign(socket, form: to_form(form))}
    end
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
