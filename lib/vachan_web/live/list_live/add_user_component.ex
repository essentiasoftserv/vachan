defmodule VachanWeb.ListLive.AddUserComponent do
  use VachanWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div id="list-id">
      <.search_bar></.search_bar>
      <form phx-submit="save">
        <.table id="people" rows={@search_person_detail}>
          <:col :let={{_id, person}} label="First Name"><%= person.first_name %></:col>
          <:col :let={{_id, person}} label="Last Name"><%= person.last_name %></:col>
          <:col :let={{_id, person}} label="Email"><%= person.email %></:col>
          <:action :let={{_id, person}}>
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
        <.button type="submit">Save</.button>
      </form>
    </div>
    """
  end
end
