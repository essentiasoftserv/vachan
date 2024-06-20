defmodule VachanWeb.PersonLive.Index do
  use VachanWeb, :live_view

  alias Vachan.Crm.Person

  @impl true
  def mount(_params, _session, socket) do
    {:ok, people} = Person.read_all(ash_opts(socket))
    {:ok, stream(socket, :people, people)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Person")
    |> assign(:person, Person.get_by_id!(id, ash_opts(socket)))
    |> assign(:action, :edit)
  end

  defp apply_action(socket, :add_to_list, %{"id" => id}) do
    socket
    |> assign(:page_title, "Add to Lists")
    |> assign(:person, Person.get_by_id!(id, ash_opts(socket)))
    |> assign(:action, :add_to_list)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Person")
    |> assign(:person, %Person{})
    |> assign(:action, :new)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing People")
    |> assign(:person, nil)
  end

  @impl true
  def handle_info({VachanWeb.PersonLive.FormComponent, {:saved, person}}, socket) do
    socket =
      socket
      |> clear_flash()
      |> put_flash(:info, get_flash_message(socket.assigns.action))
      |> stream_insert(:people, person)

    Process.send_after(self(), :clear_flash, 2000)
    {:noreply, socket}
  end

  @impl true
  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    person = Person.get_by_id!(id, ash_opts(socket))
    {:ok, _} = Person.destroy(person, ash_opts(socket))

    {:noreply, stream_delete(socket, :people, person)}
  end

  @impl true
  def handle_event("add_to_list", %{"id" => _id}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    people = search_people_by_first_name(query, socket)

    if String.trim(query) == "" do
      {:noreply, assign(socket, people: people)}
    else
      {:noreply, stream(socket, :people, people, reset: true)}
    end
  end

  defp search_people_by_first_name(query, socket) when is_binary(query) do
    {:ok, people} = Person.read_all(ash_opts(socket))
    capitalized_query = String.capitalize(query)

    Enum.filter(people, fn person ->
      String.contains?(String.capitalize(person.first_name), capitalized_query)
    end)
  end
  defp get_flash_message(:new), do: "Person created successfully"
  defp get_flash_message(:edit), do: "Person updated successfully"
  defp get_flash_message(_), do: ""
end
