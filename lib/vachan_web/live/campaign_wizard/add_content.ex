defmodule VachanWeb.CampaignWizard.ContentStep do
  use VachanWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mt-20">
      <div>
        <.simple_form
          id="content-form"
          for={@form}
          phx-change="validate"
          phx-submit="save"
          phx-target={@myself}
          class="p-4"
        >
          <.input
            field={@form[:subject]}
            type="text"
            label="Subject"
            placeholder="How is {{company}}'s marketing campaign holding up?"
          >
          </.input>

          <.input
            field={@form[:text_body]}
            type="textarea"
            label="Email Body"
            placeholder="The body of the email"
          >
          </.input>

          <.input field={@form[:campaign_id]} type="hidden" value={@campaign.id}></.input>

          <:actions>
            <.button phx-disable-with="Saving ... ">Save content</.button>
          </:actions>
        </.simple_form>
      </div>

      <div>
        <h1>extracted variables:</h1>
        <%= for variable <- @extracted_variables do %>
          <%= variable %>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:extracted_variables, [])
     |> assign(form: create_form(assigns))}
  end

  @impl true
  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)

    extracted_variables =
      extract_strings(params["text_body"]) ++ extract_strings(params["subject"])

    {:noreply,
     socket
     |> assign(:form, to_form(form))
     |> assign(:extracted_variables, extracted_variables)}
  end

  @impl true
  def handle_event("save", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)

    case AshPhoenix.Form.submit(form) do
      {:ok, content} ->
        # notify_parent({:content, content})

        {:noreply,
         socket
         |> put_flash(:info, "Content Saved")
         |> push_patch(to: socket.assigns.next_f.(socket.assigns.campaign.id))}

      {:error, form} ->
        IO.inspect(form)
        {:noreply, assign(socket, form: to_form(form))}
    end
  end

  defp create_form(assigns) do
    Vachan.Massmail.Content
    |> AshPhoenix.Form.for_create(
      :create,
      ash_opts(assigns, domain: Vachan.Massmail)
    )
    |> to_form()
  end

  defp extract_strings(input_string) do
    ~r/{{(.*?)}}/s
    |> Regex.scan(input_string)
    |> Enum.map(&List.last(&1))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
