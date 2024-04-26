defmodule VachanWeb.PersonLive.Index do
  import Ash.Page.Offset

  use VachanWeb, :live_view

  alias Vachan.Crm.Person

  @impl true
  def mount(_params, _session, socket) do
    {:ok, people} = Person.read_all(ash_opts(socket))

    {:ok,
     socket
     |> stream(:people, people)}
  end

  def ash_opts(socket, opts \\ []) do
    Keyword.merge(
      [actor: socket.assigns[:current_user], tenant: socket.assigns[:current_org].id],
      opts
    )
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Person")
    |> assign(:person, Person.get_by_id!(id, ash_opts(socket)))
  end

  defp apply_action(socket, :add_to_list, %{"id" => id}) do
    socket
    |> assign(:page_title, "Add to Lists")
    |> assign(:person, Person.get_by_id!(id, ash_opts(socket)))
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
    person = Person.get_by_id!(id, ash_opts(socket))
    {:ok, _} = Person.destroy(person, ash_opts(socket))

    {:noreply, stream_delete(socket, :people, person)}
  end

  @impl true
  def handle_event("add_to_list", %{"id" => id}, socket) do
    {:noreply, socket}
  end

  # def handle_event("next_page", %{"key_id" => key_id}, socket) do
  #   {:ok, people} = Person.read_all(ash_opts(socket, page: [after: key_id]))
  #   last_record = List.last(people.results)
  #   prev_record = List.first(people.results)

  #   {:noreply,
  #    assign(socket, :last_record, last_record)
  #    |> assign(:people, people)
  #    |> assign(:prev_record, prev_record)
  #    |> stream(:page, people.results, reset: true)}
  # end

  # def handle_event("prev_page", %{"key_id" => key_id}, socket) do
  #   {:ok, people} = Person.read_all(ash_opts(socket, page: [before: key_id]))
  #   prev_record = List.first(people.results)
  #   last_record = List.last(people.results)

  #   {:noreply,
  #    assign(socket, :last_record, last_record)
  #    |> assign(:people, people)
  #    |> assign(:prev_record, prev_record)
  #    |> stream(:page, people.results, reset: true)}

  # end

  # @impl true
  # def handle_event("search", %{"query" => query}, socket) do
  #   people = search_people_by_first_name(query, socket)

  #   if String.trim(query) == "" do
  #     {:noreply, assign(socket, people: people)}
  #   else
  #     {:noreply, stream(socket, :current_page_people, people, reset: true)}
  #   end
  # end

  # defp search_people_by_first_name(query, socket) when is_binary(query) do
  #   {:ok, people} = Person.read_all(ash_opts(socket))
  #   capitalized_query = String.capitalize(query)

  #   matching_people_data =
  #     Enum.filter(people, fn person ->
  #       String.contains?(String.capitalize(person.first_name), capitalized_query)
  #     end)
  # end
end
