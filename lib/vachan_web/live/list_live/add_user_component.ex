defmodule VachanWeb.ListLive.AddUserComponent do
  use VachanWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div id="list-id">
      <.search_bar></.search_bar>
      <%= if @search_person_detail== [] do %>
      <% else %>
        <form phx-submit="save">
          <.table id="add-to-list-table" rows={@search_person_detail}>
            <:col :let={person} label="First name"><%= person.first_name %></:col>
            <:col :let={person} label="List name"><%= person.last_name %></:col>
            <:col :let={person} label="Email"><%= person.email %></:col>
            <:action :let={person}>
              <%= if person.id in @person_details do %>
                <input
                  type="checkbox"
                  name="selected_people[]"
                  value={person.id}
                  checked={person.id in @person_details}
                />
              <% else %>
                <input type="checkbox" name="selected_people[]" value={person.id} />
              <% end %>
            </:action>
          </.table>
          <input type="hidden" name="list_id" value={@list.id} />
          <.button type="submit" class="mt-8">Save</.button>
        </form>
      <% end %>
    </div>
    """
  end
end
