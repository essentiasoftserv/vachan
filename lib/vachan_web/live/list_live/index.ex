defmodule VachanWeb.ListLive.Index do
  use VachanWeb, :live_view

  alias Vachan.Crm.List

  @impl true
  def mount(_params, _session, socket) do
    {:ok, lists} = List.read_all(ash_opts(socket))

    {:ok,
     socket
     |> stream(:lists, lists)}
  end

  @impl true
  def handle_params(params, _url, socket) do
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
    list = List.get_by_id!(id, ash_opts(socket))
    {:ok, _} = List.destroy(list, ash_opts(socket))

    {:noreply, stream_delete(socket, :lists, list)}
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
end
