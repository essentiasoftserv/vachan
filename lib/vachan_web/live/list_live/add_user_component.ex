defmodule VachanWeb.ListLive.AddUserComponent do
  use VachanWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div id="list-id">
      <.search_bar></.search_bar>
      <%= if @search_person_detail== [] do %>
      <% else %>
        <form phx-submit="save" class="mt-4">
          <.table id="add-to-list-table" rows={@search_person_detail}>
            <:col :let={person} label="First name"><%= person.first_name %></:col>
            <:col :let={person} label="List name"><%= person.last_name %></:col>
            <:col :let={person} label="Email"><%= person.email %></:col>
            <:action :let={person}>
              <input type="checkbox" checked={person.id in @person_details} />
            </:action>
          </.table>
          <.button type="submit" class="mt-8">Save</.button>
        </form>
      <% end %>
    </div>
    """
  end
end
