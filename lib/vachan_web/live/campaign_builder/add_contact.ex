defmodule VachanWeb.CampaignBuilder.AddContact do
  use VachanWeb, :live_component

  defmodule Contact do
    use Ecto.Schema
    import Ecto.Changeset

    schema "contacts" do
      field :list_name, :string
      field :contacts_csv, :string
    end

    def changeset(contact, params \\ %{}) do
      contact
      |> cast(params, [:list_name, :contacts_csv])
      |> validate_required([:list_name, :contacts_csv])
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6">
    <h1 class="text-2xl font-bold text-center mb-4">Create A New List</h1>
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
    Contact.changeset(%Contact{}, params)
  end

  @impl true
  def update(_assigns, socket) do
    changeset = get_changeset(%{})
    {:ok,
     socket
     |> assign(:form, to_form(changeset, as: "contact"))
     |> assign(:column_names, [])}
  end

  @impl true
  def handle_event("validate", %{"contact" => params}, socket) do
    form = get_changeset(params)

    case params["contacts_csv"] do
      nil ->
        {:noreply,
         socket
         |> assign(:form, to_form(form, as: "contact"))
         |> assign(:parsed_data, [])
         |> assign(:headers, [])}
      csv_data ->
        [headers | parsed_data] = csv_to_array(csv_data)

        {:noreply,
         socket
         |> assign(:form, to_form(form, as: "contact"))
         |> assign(:parsed_data, parsed_data)
         |> assign(:headers, headers)}
    end
  end

  @impl true
  def handle_event("save", %{"contact" => params}, socket) do
    form = get_changeset(params)

    if form.valid? do
      # Save to the database or perform your save logic here
      # Example: Vachan.Repo.insert!(form)
      {:noreply,
       socket
       |> put_flash(:info, "List saved successfully.")
       |> assign(:form, to_form(form, as: "contact"))}
    else
      {:noreply,
       socket
       |> put_flash(:error, "Error saving the list.")
       |> assign(:form, to_form(form, as: "contact"))}
    end
  end

  defp csv_to_array(nil), do: []

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
