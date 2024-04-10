defmodule VachanWeb.ListLive.Index do
  use VachanWeb, :live_view

  alias Vachan.Crm
  alias Vachan.Crm.List

  @page_limit 10

  @impl true
  def mount(_params, _session, socket) do
    {:ok, lists} = List.read_all()
    total_count = length(lists)
    initial_page = get_page(lists, 1)

    {:ok,
     assign(socket,
       lists: lists,
       total_count: total_count,
       page_limit: @page_limit,
       current_page: 1
     )
     |> stream(:current_page_list, initial_page)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit List")
    |> assign(:list, List.get_by_id!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New List")
    |> assign(:list, %List{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing People")
    |> assign(:list, nil)
  end

  @impl true
  def handle_info({VachanWeb.ListLive.FormComponent, {:saved, list}}, socket) do
    {:noreply, stream_insert(socket, :lists, list)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    list = List.get_by_id!(id)
    {:ok, _} = List.destroy(List)

    {:noreply, stream_delete(socket, :lists, list)}
  end

  def handle_event("next_page", _params, socket) do
    %{current_page: current_page, total_count: total_count, page_limit: page_limit} =
      socket.assigns

    new_page = min(current_page + 1, div(total_count, page_limit) + 1)
    new_page_list = get_page(socket.assigns.lists, new_page)

    {:noreply,
     assign(socket, current_page: new_page)
     |> stream(:current_page_list, new_page_list, reset: true)}
  end

  def handle_event("prev_page", _params, socket) do
    %{current_page: current_page} = socket.assigns
    new_page = max(current_page - 1, 1)
    new_page_list = get_page(socket.assigns.lists, new_page)

    {:noreply,
     assign(socket, current_page: new_page)
     |> stream(:current_page_list, new_page_list, reset: true)}
  end

  defp get_page(lists, page) do
    Enum.slice(lists, ((page - 1) * @page_limit)..(page * @page_limit))
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    lists = search_list_by_first_name(query)
    {:noreply, stream(socket, :current_page_list, lists, reset: true)}
  end

  defp search_list_by_first_name(query) when is_binary(query) do
    {:ok, lists} = List.read_all()
    capitalized_query = String.capitalize(query)

    matching_list_data =
      Enum.filter(lists, fn list ->
        String.contains?(String.capitalize(list.name), capitalized_query)
      end)
  end
end
