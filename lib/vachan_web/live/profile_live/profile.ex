defmodule VachanWeb.ProfileLive.Profile do
  use VachanWeb, :live_view

  alias Vachan.Profiles

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Create / Update your profile</:subtitle>
      </.header>

      <.simple_form for={@form} id="profile-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="First Name" />
        <.input field={@form[:last_name]} type="text" label="Last Name" />
        <.input field={@form[:email]} type="text" label="Email" value={@email} readonly />
        <.input field={@form[:company]} type="text" label="Company" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Profile</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    socket =
      socket
      |> assign(:title, "Profile")
      |> assign(page: :profile)
      |> assign_new(:email, fn -> user.email end)
      |> init_form(user)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("save", %{"form" => params}, socket) do
    params = Map.put(params, "id", socket.assigns.current_user.id)
    form = AshPhoenix.Form.validate(socket.assigns.form, params)

    case AshPhoenix.Form.submit(form) do
      {:ok, result} ->
        form =
          AshPhoenix.Form.for_update(result, :update,
            api: Profiles,
            actor: socket.assigns.current_user,
            forms: [auto?: true]
          )
          |> to_form()

        {:noreply, assign(socket, form: form)}

      {:error, form} ->
        {:noreply, assign(socket, form: to_form(form))}
    end
  end

  defp init_form(socket, user) do
    case Ash.get(Profiles.Profile, user.id, actor: user) do
      {:ok, profile} ->
        form =
          AshPhoenix.Form.for_update(profile, :update,
            api: Profiles,
            actor: user,
            forms: [auto?: true]
          )
          |> to_form()

        assign(socket, form: form)

      {:error, _} ->
        form =
          AshPhoenix.Form.for_create(Profiles.Profile, :create,
            api: Profiles,
            actor: user,
            forms: [auto?: true]
          )
          |> to_form()

        assign(socket, form: form)
    end
  end
end
