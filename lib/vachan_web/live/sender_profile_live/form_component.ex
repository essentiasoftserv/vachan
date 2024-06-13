defmodule VachanWeb.SenderProfileLive.FormComponent do
  use VachanWeb, :live_component

  alias Vachan.SenderProfiles.SenderProfile

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage Sender Profile records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="sender-profile-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Sender Profile's title" placeholder="Profile title"/>
        <.input field={@form[:name]} type="text" label="Sender's Name" placeholder="Name"/>
        <.input field={@form[:email]} type="email" label="Sender's Email" placeholder="E-mail" />

        <.input field={@form[:smtp_host]} type="text" label="SMTP Server's Address" placeholder="Server's address" />
        <.input field={@form[:smtp_port]} type="number" label="SMTP Server's Port" placeholder="Server's port" />
        <.input field={@form[:username]} type="text" label="SMTP username"  placeholder="Username"/>
        <.input field={@form[:password]} type="text" label="SMTP password" placeholder="Password...."/>

        <:actions>
          <.button phx-disable-with="Saving...">Save Sender Profile</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  defp create_form(assigns) do
    SenderProfile
    |> AshPhoenix.Form.for_create(:create, ash_opts(assigns, domain: Vachan.SenderProfiles))
    |> to_form()
  end

  defp update_form(assigns) do
    assigns.sender_profile
    |> AshPhoenix.Form.for_update(:update, ash_opts(assigns, domain: Vachan.SenderProfiles))
    |> to_form()
  end

  @impl true
  def update(%{sender_profile: _sender_profile, action: :edit} = assigns, socket) do
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
  def handle_event("validate", %{"form" => sender_profile_params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, sender_profile_params)
    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("save", %{"form" => sender_profile_params}, socket) do
    save_sender_profile(socket, socket.assigns.action, sender_profile_params)
  end

  defp save_sender_profile(socket, :edit, sender_profile_params) do
    form = AshPhoenix.Form.validate(socket.assigns.form, sender_profile_params)

    case AshPhoenix.Form.submit(form) do
      {:ok, sender_profile} ->
        notify_parent({:saved, sender_profile})

        {:noreply,
         socket
         |> put_flash(:info, "Sender Profile updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp save_sender_profile(socket, :new, sender_profile_params) do
    form = AshPhoenix.Form.validate(socket.assigns.form, sender_profile_params)

    case AshPhoenix.Form.submit(form) do
      {:ok, sender_profile} ->
        notify_parent({:saved, sender_profile})

        {:noreply,
         socket
         |> put_flash(:info, "SenderProfile created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
