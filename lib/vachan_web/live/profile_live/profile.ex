defmodule VachanWeb.ProfileLive.Profile do
  use VachanWeb, :live_view

  alias Vachan.Profiles

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header class="ml-4">
        <%= @title %>
        <:subtitle>Create / Update your profile</:subtitle>
      </.header>

      <.simple_form for={@form} id="profile-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <%= if @name_error do %>
          <p class="error-message" style="color: red;"><%= @name_error %></p>
        <% end %>

        <.input field={@form[:email]} type="text" label="Email" value={@email} readonly />
        <:actions>
          <.button
            phx-disable-with="Saving..."
            disabled={not @name_changed}
            class={
              if @name_changed,
                do: "bg-blue-500 text-white hover:bg-blue-600",
                else: "bg-gray-300 text-gray-500 cursor-not-allowed"
            }
          >
            Save Profile
          </.button>
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
      |> assign(:name_error, nil)
      |> assign(:name_changed, false)
      |> init_form(user)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)

    name_error = socket.assigns.name_error

    name_error =
      if Map.has_key?(params, "name"), do: validate_name(params["name"]), else: name_error

    # Check if name has changed
    original_name = socket.assigns.original_name
    current_name = params["name"] || ""

    name_changed = current_name != original_name

    socket =
      assign(socket,
        form: form,
        name_error: name_error,
        name_changed: name_changed
      )

    {:noreply, socket}
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

        {:noreply, assign(socket, form: form, name_changed: false)}

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

        socket
        |> assign(:form, form)
        |> assign(:original_name, profile.name || "")

      {:error, _} ->
        form =
          AshPhoenix.Form.for_create(Profiles.Profile, :create,
            api: Profiles,
            actor: user,
            forms: [auto?: true]
          )
          |> to_form()

        socket
        |> assign(:form, form)
        |> assign(:original_name, "")
    end
  end

  defp validate_name(nil), do: ""
  defp validate_name(""), do: ""

  defp validate_name(name) do
    if String.match?(name, ~r/^[a-zA-Z\s]+$/) do
      nil
    else
      "Name should contain only letters and spaces"
    end
  end
end
