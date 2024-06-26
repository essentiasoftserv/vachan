defmodule VachanWeb.CampaignBuilder.AddContact do
  use VachanWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="">
      <.simple_form
        for={@form}
        id="list-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:list_name]} type="text" label="List Name" />
        <.input
          field={@form[:contacts_csv]}
          type="textarea"
          label="Contacts CSV"
          placeholder="email, first_name, last_name
    james@mi5.gov.uk, James, Bond
    harry@hogwarts.edu, Harry, Potter
    "
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save list</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def get_changeset(params) do
    data = %{}
    types = %{list_name: :string, contacts_csv: :string}

    {data, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
  end

  defp validate(params) do
    data = %{}
    types = %{list_name: :string, contacts_csv: :string}

    {data, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_required(:list_name, :contacts_csv)
  end

  @impl true
  def update(_assigns, socket) do
    {:ok,
     socket
     |> assign(:form, to_form(get_changeset(%{}), as: "contact"))
     |> assign(:column_names, [])}
  end

  @impl true
  def handle_event("validate", params, socket) do
    form = validate(params)
    [headers | parsed_data] = csv_to_array(params["blob"])

    {:noreply,
     socket
     |> assign(:form, to_form(form))
     |> assign(:parsed_data, parsed_data)
     |> assign(:headers, headers)}
  end

  @impl true
  def handle_event("save", params, socket) do
    {:noreply, socket}
  end

  defp csv_to_array(blob) do
    blob
    |> String.trim()
    |> String.split("\n")
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn line ->
      String.split(line, ",")
      |> Stream.map(&String.trim/1)
      |> Enum.to_list()
    end)
    |> Enum.to_list()
  end
end
