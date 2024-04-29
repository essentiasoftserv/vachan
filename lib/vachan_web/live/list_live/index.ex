defmodule VachanWeb.ListLive.Index do
  use VachanWeb, :live_view

  alias Vachan.Crm.List

  @impl true
  def mount(_params, _session, socket) do
    List.read_all(ash_opts(socket))

    {:ok,
     socket
     |> assign(:pages, 0)
     |> assign(:active_page, 1)
     |> assign(:page_offset, 0)
     |> assign(:page_limit, 50)
     |> stream(:lists, [])}
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
    |> assign(:page_title, "Edit List")
    |> assign(:list, List.get_by_id!(id, ash_opts(socket)))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New List")
    |> assign(:list, %List{})
  end

  defp apply_action(socket, :index, _params) do
    page = pagination_count_list(socket)

    socket
    |> assign(:page_title, "Listing People")
    |> assign(:list, nil)
    |> stream(:lists, page.results, reset: true)
    |> assign(:pages, ceil(page.count / socket.assigns.page_limit))
  end

  @impl true
  def handle_info({VachanWeb.ListLive.FormComponent, {:saved, list}}, socket) do
    {:noreply, stream_insert(socket, :lists, list)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    list = List.get_by_id!(id, ash_opts(socket))
    {:ok, _} = List.destroy(list, ash_opts(socket))

    {:noreply, stream_delete(socket, :lists, list)}
  end

  defp pagination_count_list(socket) do
    page_count = [limit: socket.assigns.page_limit, offset: socket.assigns.page_offset]
    List.list!(ash_opts(socket, page: page_count))
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    lists = search_list_by_first_name(query, socket)
    {:noreply, stream(socket, :lists, lists, reset: true)}
  end

  defp search_list_by_first_name(query, socket) when is_binary(query) do
    {:ok, lists} = List.read_all(ash_opts(socket))
    capitalized_query = String.capitalize(query)

    Enum.filter(lists, fn list ->
      String.contains?(String.capitalize(list.name), capitalized_query)
    end)
  end

  defp page(nil), do: nil

  defp page(page_param) do
    {active_page, _} = Integer.parse(page_param)
    active_page
  end

  defp page_offset(nil, _page_limit), do: nil

  defp page_offset(page_param, page_limit) do
    (page_param - 1) * page_limit
  end

  defp maybe_assign(socket, _key, nil), do: socket
  defp maybe_assign(socket, key, val), do: socket |> assign(key, val)

  def active_class(on_page, active_page) when on_page == active_page, do: "active"
  def active_class(_on_page, _active_page), do: ""
end
