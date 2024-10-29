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
        <%= if @name_error do %>
          <p class="error-message" style="color: red;"><%= @name_error %></p>
        <% end %>

        <.input field={@form[:last_name]} type="text" label="Last Name" />
        <%= if @last_name_error do %>
          <p class="error-message" style="color: red;"><%= @last_name_error %></p>
        <% end %>

        <.input field={@form[:email]} type="text" label="Email" value={@email} readonly />

        <.input field={@form[:company]} type="text" label="Company" />
        <%= if @company_error do %>
          <p class="error-message" style="color: red;"><%= @company_error %></p>
        <% end %>

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
      |> assign(:name_error, nil)
      |> assign(:last_name_error, nil)
      |> assign(:company_error, nil)
      |> init_form(user)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)

    name_error = socket.assigns.name_error
    last_name_error = socket.assigns.last_name_error
    company_error = socket.assigns.company_error

    name_error = if Map.has_key?(params, "name"), do: validate_first_name(params["name"]), else: name_error
    last_name_error = if Map.has_key?(params, "last_name"), do: validate_last_name(params["last_name"]), else: last_name_error
    company_error = if Map.has_key?(params, "company"), do: validate_company(params["company"]), else: company_error

    socket =
      assign(socket, form: form, name_error: name_error, last_name_error: last_name_error, company_error: company_error)

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

  defp validate_first_name(nil), do: ""
  defp validate_first_name(""), do: ""
  defp validate_first_name(name) do
    if String.match?(name, ~r/^[a-zA-Z\s]+$/) do
      nil
    else
      "First name should contain only letters and spaces"
    end
  end

  defp validate_last_name(nil), do: ""
  defp validate_last_name(""), do: ""
  defp validate_last_name(last_name) do
    if String.match?(last_name, ~r/^[a-zA-Z\s]+$/) do
      nil
    else
      "Last name should contain only letters and spaces"
    end
  end

  defp validate_company(company) do
    if String.match?(company, ~r/^[a-zA-Z0-9\s]+$/) do
      nil
    else
      "Company name should contain only letters, numbers, and spaces"
    end
  end
end
