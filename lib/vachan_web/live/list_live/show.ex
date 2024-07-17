defmodule VachanWeb.ListLive.Show do
  use VachanWeb, :live_view

  alias Vachan.Crm

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
    socket

  }
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    if connected?(socket) do
      VachanWeb.Endpoint.subscribe("person_list:destroyed")
    end

    list = Crm.List.get_by_id!(id, ash_opts(socket))
    person_details = get_person_details_for_list(list, socket)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:person_details, person_details)
     |> assign(:search_person_detail, person_details)
     |> assign(:checked_people_ids, [])
     |> assign(:query, "")
     |> assign(:list, Crm.List.get_by_id!(id, ash_opts(socket)))}
  end

  @impl true
  def handle_event("remove_from_lists", %{"id" => id, "person_id" => person_id}, socket) do
    list = Crm.List.get_by_id!(id, ash_opts(socket))
    {:ok, _} = Crm.List.remove_person(list, person_id, ash_opts(socket))
    {:noreply, socket}
  end

  @impl true
  def handle_event("checked_people", %{"checked_people_id" => checked_people_id}, socket) do
    {:noreply, socket}
  end

  @impl true
  # def handle_event("save", params, socket) do
  def handle_event("save", %{"form" => params}, socket) do
    IO.inspect("********")
    IO.inspect(socket.assigns.form)
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{topic: "person_list:destroyed", payload: _payload}, socket) do
    handle_modification(socket)
  end

  defp handle_modification(socket) do
    person_details = get_person_details_for_list(socket.assigns.list, socket)

    {:noreply,
     socket
     |> assign(:person_details, person_details)
     |> put_flash(:info, "Person details removed successfully")}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    search_person_detail = search_people_by(query, socket)
    if String.trim(query) == "" do
      {:noreply, socket}
    else
      {:noreply, assign(socket, search_person_detail: search_person_detail, reset: true)}
    end
  end

  defp get_person_details_for_list(list, socket) do
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

  defp search_people_by(query, socket) when is_binary(query) do
    search_person_detail = get_person_details_for_list(socket.assigns.list, socket)
    capitalized_query = String.capitalize(query)
    filtered_list =Enum.filter(search_person_detail, fn record ->
      record[:first_name] == capitalized_query
    end)
    filtered_list
  #   new_socket = assign(socket, :filtered_people, filtered_list)
  # {:ok, new_socket}
  end

  defp page_title(:show), do: "Show List"
  defp page_title(:edit), do: "Edit List"
end
