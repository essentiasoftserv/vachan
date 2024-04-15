defmodule VachanWeb.PersonLive.Index do
  use VachanWeb, :live_view

  alias Vachan.Crm.Person
  alias Vachan.Crm.List

  @page_limit 10

  @impl true
  def mount(_params, _session, socket) do
    {:ok, people} = Person.read_all()
    total_count = length(people)
    initial_page = get_page(people, 1)

    {:ok,
     assign(socket,
       people: people,
       total_count: total_count,
       page_limit: @page_limit,
       current_page: 1
     )
     |> stream(:current_page_people, initial_page)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Person")
    |> assign(:person, Person.get_by_id!(id))
  end

  defp apply_action(socket, :add_to_list, %{"id" => id}) do
    socket
    |> assign(:page_title, "Add to Lists")
    |> assign(:person, Person.get_by_id!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Person")
    |> assign(:person, %Person{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing People")
    |> assign(:person, nil)
  end

  @impl true
  def handle_info({VachanWeb.PersonLive.FormComponent, {:saved, person}}, socket) do
    {:noreply, stream_insert(socket, :people, person)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    person = Person.get_by_id!(id)
    {:ok, _} = Person.destroy(person)

    {:noreply, stream_delete(socket, :people, person)}
  end

  @impl true
  def handle_event("add_to_list", %{"id" => id}, socket) do
    {:noreply, socket}
  end

  def handle_event("next_page", _params, socket) do
    %{current_page: current_page, total_count: total_count, page_limit: page_limit} =
      socket.assigns

    new_page = min(current_page + 1, div(total_count, page_limit) + 1)
    new_page_people = get_page(socket.assigns.people, new_page)

    {:noreply,
     assign(socket, current_page: new_page)
     |> stream(:current_page_people, new_page_people, reset: true)}
  end

  def handle_event("prev_page", _params, socket) do
    %{current_page: current_page} = socket.assigns
    new_page = max(current_page - 1, 1)
    new_page_people = get_page(socket.assigns.people, new_page)

    {:noreply,
     assign(socket, current_page: new_page)
     |> stream(:current_page_people, new_page_people, reset: true)}
  end

  defp get_page(people, page) do
    Enum.slice(people, ((page - 1) * @page_limit)..(page * @page_limit))
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    people = search_people_by_first_name(query)

    if String.trim(query) == "" do
      {:noreply, assign(socket, people: people)}
    else
      {:noreply, stream(socket, :current_page_people, people, reset: true)}
    end
  end

  defp search_people_by_first_name(query) when is_binary(query) do
    {:ok, people} = Person.read_all()
    capitalized_query = String.capitalize(query)

    matching_people_data =
      Enum.filter(people, fn person ->
        String.contains?(String.capitalize(person.first_name), capitalized_query)
      end)
  end
end
