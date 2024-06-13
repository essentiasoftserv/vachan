defmodule VachanWeb.PersonLive.FormComponent do
  use VachanWeb, :live_component

  alias Vachan.Crm

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage person records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="person-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:first_name]} type="text" label="First name" placeholder="First Name"/>
        <.input field={@form[:last_name]} type="text" label="Last name" placeholder="Last Name"/>
        <.input field={@form[:email]} type="email" label="Email" placeholder="E-mail"/>

        <:actions>
          <.button phx-disable-with="Saving...">Save Person</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  defp create_form(assigns) do
    Crm.Person
    |> AshPhoenix.Form.for_create(:create, ash_opts(assigns, api: Crm))
    |> to_form()
  end

  defp update_form(assigns) do
    assigns.person
    |> AshPhoenix.Form.for_update(:update, ash_opts(assigns, api: Crm))
    |> to_form()
  end

  @impl true
  def update(%{person: _person, action: :edit} = assigns, socket) do
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
  def handle_event("validate", %{"form" => person_params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, person_params)
    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("save", %{"form" => person_params}, socket) do
    save_person(socket, socket.assigns.action, person_params)
  end

  defp save_person(socket, :edit, person_params) do
    form = AshPhoenix.Form.validate(socket.assigns.form, person_params)

    case AshPhoenix.Form.submit(form) do
      {:ok, person} ->
        notify_parent({:saved, person})

        {:noreply,
         socket
         |> put_flash(:info, "Person updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp save_person(socket, :new, person_params) do
    form = AshPhoenix.Form.validate(socket.assigns.form, person_params)

    case AshPhoenix.Form.submit(form) do
      {:ok, person} ->
        notify_parent({:saved, person})

        {:noreply,
         socket
         |> put_flash(:info, "Person created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
