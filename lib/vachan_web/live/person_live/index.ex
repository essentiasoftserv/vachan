defmodule VachanWeb.PersonLive.Index do
  import Ash.Page.Offset

  use VachanWeb, :live_view

  alias Vachan.Crm.Person

  @impl true
  def mount(_params, _session, socket) do
    Person.read_all!(ash_opts(socket))

    {:ok,
     socket
     |> assign(:pages, 0)
     |> assign(:active_page, 1)
     |> assign(:page_offset, 0)
     |> assign(:page_limit, 5)
     |> stream(:people, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> maybe_assign(:active_page, page(params["page"]))
      |> maybe_assign(:page_offset, page_offset(page(params["page"]), socket.assigns.page_limit))

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
    page = list_people(socket)

    socket
    |> assign(:page_title, "Listing People")
    |> assign(:person, nil)
    |> stream(:people, page.results, reset: true)
    |> assign(:pages, ceil(page.count / socket.assigns.page_limit))
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

  defp list_people(socket) do
    page_count = [limit: socket.assigns.page_limit, offset: socket.assigns.page_offset]
    Person.list!(ash_opts(socket, page: page_count))
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

  defp page(nil), do: nil

  defp page(page_param) do
    {active_page, _} = Integer.parse(page_param)
    active_page
  end

  defp page_offset(nil, _page_limit), do: nil

  defp page_offset(page_param, page_limit) do
    IO.inspect((page_param - 1) * page_limit)
    (page_param - 1) * page_limit
  end

  defp maybe_assign(socket, _key, nil), do: socket
  defp maybe_assign(socket, key, val), do: socket |> assign(key, val)

  def active_class(on_page, active_page) when on_page == active_page, do: "active"
  def active_class(_on_page, _active_page), do: ""
end
