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

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:person_details, person_details)
     |> assign(:list, Crm.List.get_by_id!(id, ash_opts(socket)))}
  end

  @impl true
  def handle_event("remove_from_lists", %{"id" => id, "person_id" => person_id}, socket) do
    list = Crm.List.get_by_id!(id, ash_opts(socket))
    {:ok, _} = Crm.List.remove_person(list, person_id, ash_opts(socket))
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
     |> assign(:person_details, person_details)}
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
