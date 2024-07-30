defmodule VachanWeb.ListLive.Show do
  use VachanWeb, :live_view

  alias Vachan.Crm

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    if connected?(socket) do
      VachanWeb.Endpoint.subscribe("person_list:destroyed")
    end

    list = Crm.List.get_by_id!(id, ash_opts(socket))
    person_details = get_person_details_for_list(list, socket)
    user_detail = get_user_detail(list, socket)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:person_details, person_details)
     |> assign(:user_detail, user_detail)
     |> assign(:search_person_detail, [])
     |> assign(:list, Crm.List.get_by_id!(id, ash_opts(socket)))}
  end

  @impl true
  def handle_event("remove_user_from_list", %{"id" => id, "person_id" => person_id}, socket) do
    list = Crm.List.get_by_id!(id, ash_opts(socket))
    {:ok, _} = Crm.List.remove_person(list, person_id, ash_opts(socket))
    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "add_to_user_list",
        %{"person_id" => person_id, "list_id" => list_id},
        socket
      ) do
    list = Crm.List.get_by_id!(list_id, ash_opts(socket))
    {:ok, _} = Crm.List.add_person(list, person_id, ash_opts(socket))
    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "remove_from_user_list",
        %{"person_id" => person_id, "list_id" => list_id},
        socket
      ) do
    list = Crm.List.get_by_id!(list_id, ash_opts(socket))
    {:ok, _} = Crm.List.remove_person(list, person_id, ash_opts(socket))
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{topic: "person_list:destroyed", payload: _payload}, socket) do
    handle_modification(socket)
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    filtered_list = filter_by_first_name(query, socket)
    existing_person_detail = socket.assigns.search_person_detail
    updated_results = merge_without_duplicates(existing_person_detail, filtered_list)
    {:noreply, assign(socket, search_person_detail: updated_results, reset: true)}
  end

  def handle_event("save", _params, socket) do
    {:noreply, assign(socket, live_action: nil)}
  end

  defp handle_modification(socket) do
    person_details = get_person_details_for_list(socket.assigns.list, socket)

    {:noreply,
     socket
     |> assign(:person_details, person_details)
     |> put_flash(:info, "Person details removed successfully")}
  end

  defp get_person_details_for_list(list, socket) do
    list
    |> Ash.load!(:people, ash_opts(socket))
    |> then(fn x -> x.people end)
    |> Enum.map(fn x -> x.id end)
  end

  defp get_user_detail(list, socket) do
    list
    |> Ash.load!(:people, ash_opts(socket))
    |> then(fn x -> x.people end)
    |> Enum.map(fn x ->
      %{
        id: x.id,
        first_name: x.first_name,
        last_name: x.last_name,
        email: to_string(x.email)
      }
    end)
  end

  defp filter_by_first_name(query, socket) do
    search_person_detail = Crm.Person.read_all!(ash_opts(socket))
    capitalized_query = String.capitalize(query)
    search_person_detail
    |> Enum.filter(fn person ->
      String.contains?(String.downcase(person.first_name), String.downcase(capitalized_query))
    end)
  end

  defp merge_without_duplicates(existing_list, new_list) do
    existing_ids = MapSet.new(Enum.map(existing_list, & &1.id))
    new_list
    |> Enum.reject(fn person -> MapSet.member?(existing_ids, person.id) end)
    |> Enum.concat(existing_list)
  end

  defp page_title(:show), do: "Show List"
  defp page_title(:edit), do: "Add User"
end
