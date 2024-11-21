defmodule VachanWeb.ListLive.AddUserComponent do
  use VachanWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div id="list-id">
      <.search_bar phx-change="search_changed" />
      <form phx-submit="save">
        <%= if @search_person_detail && Enum.any?(@search_person_detail) do %> <!-- Check if the list is non-empty -->
          <.table id="add-to-list-table" rows={@search_person_detail}>
            <:col :let={person} label="First name"><%= person.first_name %></:col>
            <:col :let={person} label="Last name"><%= person.last_name %></:col>
            <:col :let={person} label="Email"><%= person.email %></:col>
            <:action :let={person}>
              <%= if person.id in @person_details do %>
                <input
                  type="checkbox"
                  checked={person.id in @person_details}
                  phx-click={
                    JS.push("remove_from_user_list",
                      value: %{person_id: person.id, list_id: @list.id}
                    )
                  }
                />
              <% else %>
                <input
                  type="checkbox"
                  phx-click={
                    JS.push("add_to_user_list",
                      value: %{person_id: person.id, list_id: @list.id}
                    )
                  }
                />
              <% end %>
            </:action>
          </.table>
        <% else %>
          <!-- Optionally, you can display a message here if no search results are found -->
        <% end %>
        <div class="mt-4">
          <.button type="submit" class="px-4 py-2">Save</.button>
        </div>
      </form>
    </div>
    """
  end
end
