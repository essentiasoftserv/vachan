defmodule VachanWeb.ListLive.Show do
  use VachanWeb, :live_view

  alias Vachan.Crm

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
    socket
    |> assign(:modal_visible, false)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    if connected?(socket) do
      VachanWeb.Endpoint.subscribe("person_list:destroyed")
    end

    mylists = Crm.List.read_all!(ash_opts(socket))
    list = Crm.List.get_by_id!(id, ash_opts(socket))
    person_details = get_person_details_for_list(list, socket)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:person_details, person_details)
     |> assign(:mylists, mylists)
     |> assign(:get_list, [])
     |> assign(:list, Crm.List.get_by_id!(id, ash_opts(socket)))}
  end

  @impl true
  def handle_event("remove_from_lists", %{"id" => id, "person_id" => person_id}, socket) do
    list = Crm.List.get_by_id!(id, ash_opts(socket))
    {:ok, _} = Crm.List.remove_person(list, person_id, ash_opts(socket))
    {:noreply, socket}
  end


   def handle_event("show_modal", %{"person_id" => person_id, "person_name" => person_name}, socket) do
    person = Crm.Person.get_by_id!(person_id, ash_opts(socket))
    get_list = get_list_person(person, socket)
    IO.inspect(get_list, label: "person_id")
    # {:noreply, assign(socket, :modal_visible, true)}
    {:noreply,
    socket
    |> assign(:modal_visible, true)
    |> assign(:person_id, person_id)
    |> assign(:person_name, person_name)
    |> assign(:get_list, get_list)}
  end

  @impl true
  def handle_event("add_list", %{"person_id" => person_id, "list_id" => list_id}, socket) do
    list = Crm.List.get_by_id!(list_id, ash_opts(socket))
    {:ok, _} = Crm.List.add_person(list, person_id, ash_opts(socket))
    {:noreply, socket}
  end

  defp get_list_person(person, socket) do
    person
    |> Ash.load!(:lists, ash_opts(socket))
    |> then(fn x -> x.lists end)
    |> Enum.map(fn x -> x.id end)
  end

  def handle_event("hide_modal", _params, socket) do
    {:noreply, assign(socket, :modal_visible, false)}
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

  defp page_title(:show), do: "Show List"
  defp page_title(:edit), do: "Edit List"
end
