defmodule VachanWeb.ListLive.Index do
  use VachanWeb, :live_view

  alias Vachan.Crm
  # alias Vachan.Crm.List

  @impl true
  def mount(_params, _session, socket) do
    {:ok, page} = Crm.List.read_all()
    last_record = List.last(page.results)
    prev_record = List.first(page.results)
    {:ok,
    assign(socket,
      :last_record, last_record)
     |> assign(:lists, page)
     |> assign(:prev_record, prev_record)
     |> stream(:page, page.results)
   }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit List")
    |> assign(:list, Crm.List.get_by_id!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New List")
    |> assign(:list, %Crm.List{})
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
    list = Crm.List.get_by_id!(id)
    {:ok, _} = Crm.List.destroy(List)

    {:noreply, stream_delete(socket, :lists, list)}
  end

  def handle_event("next_page", %{"key_id" => key_id}, socket) do
    {:ok, lists} = Crm.List.read_all(page: [after: key_id])
    last_record = List.last(lists.results)
    prev_record = List.first(lists.results)
    {:noreply,
     assign(socket,:last_record, last_record )
      |> assign(:lists, lists)
      |> assign(:prev_record, prev_record)
      |> stream(:page, lists.results,reset: true)
    }
  end

  def handle_event("prev_page", %{"key_id" => key_id}, socket) do
    {:ok, lists} = Crm.List.read_all(page: [before: key_id])
    prev_record = List.first(lists.results)
    last_record = List.last(lists.results)
     {:noreply,
     assign(socket,:last_record, last_record )
      |> assign(:lists, lists)
      |> assign(:prev_record, prev_record)
      |> stream(:page, lists.results,reset: true)
    }
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    lists = search_list_by_first_name(query)
    {:noreply, stream(socket, :page, lists, reset: true)}
  end

  defp search_list_by_first_name(query) when is_binary(query) do
    {:ok, lists} = Crm.List.read_all()
    capitalized_query = String.capitalize(query)
    matching_list_data =
      Enum.filter(lists.results, fn list ->
        String.contains?(String.capitalize(list.name), capitalized_query)
      end)
  end
end
