defmodule VachanWeb.ListLive.AddListComponent do
  use VachanWeb, :live_component

  alias Vachan.Crm

  @impl true
  def render(assigns) do
    ~H"""
    <.table id="add-to-list-table" rows={@mylists}>
      <:col :let={list} label="List name"><%= list.name %></:col>
      <:col :let={list} label="List namedd"><%= list.id %></:col>
      <:action :let={list}>
        <%= if list.id in @get_list do %>
          <b> Already added</b>
        <% else %>
          <.link phx-click={
            JS.push("add_list",
              value: %{list_id: list.id, person_id: @person_id}
            )
          }>
            Add
          </.link>
        <% end %>
      </:action>
    </.table>
    """
  end
end
