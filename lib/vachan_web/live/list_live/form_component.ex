defmodule VachanWeb.ListLive.FormComponent do
  use VachanWeb, :live_component

  alias Vachan.Crm

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage list records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="list-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" placeholder="List Name"/>

        <:actions>
          <.button phx-disable-with="Saving...">Save list</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  defp create_form(assigns) do
    Crm.List
    |> AshPhoenix.Form.for_create(:create, ash_opts(assigns, api: Crm))
    |> to_form()
  end

  defp update_form(assigns) do
    assigns.list
    |> AshPhoenix.Form.for_update(:update, ash_opts(assigns, api: Crm))
    |> to_form()
  end

  @impl true
  def update(%{list: _list, action: :edit} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, update_form(assigns))}
  end

  @impl true
  def update(%{action: :new} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, create_form(assigns))}
  end

  @impl true
  def handle_event("validate", %{"form" => list_params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, list_params)
    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"form" => list_params}, socket) do
    save_list(socket, socket.assigns.action, list_params)
  end

  defp save_list(socket, :edit, list_params) do
    form = AshPhoenix.Form.validate(socket.assigns.form, list_params)

    case AshPhoenix.Form.submit(form) do
      {:ok, list} ->
        notify_parent({:saved, list})

        {:noreply,
         socket
         |> put_flash(:info, "list updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp save_list(socket, :new, list_params) do
    form = AshPhoenix.Form.validate(socket.assigns.form, list_params)

    case AshPhoenix.Form.submit(form) do
      {:ok, list} ->
        notify_parent({:saved, list})

        {:noreply,
         socket
         |> put_flash(:info, "list created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
