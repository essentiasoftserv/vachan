defmodule Vachan.Massmail.Recepients do
  use Ash.Resource, domain: Vachan.Massmail, data_layer: AshPostgres.DataLayer

  resource do
    description "Recepients of a campaign go here."
  end

  postgres do
    table "campaign_recepients"
    repo Vachan.Repo
  end

  multitenancy do
    strategy :attribute
    attribute :organization_id
  end

  code_interface do
    define :create, action: :create
    define :destroy, action: :destroy
    define :read_all, action: :read
    define :get_by_id, args: [:id], action: :by_id
  end

  actions do
    defaults [:read, :destroy]

    update :update do
      primary? true
      require_atomic? false

      accept [
        :blob
      ]

      argument :campaign_id, :integer
      change manage_relationship(:campaign_id, :campaign, type: :append)
    end

    create :create do
      primary? true

      accept [
        :blob
      ]

      change fn changeset, _context ->
        nil
      end

      argument :campaign_id, :integer, allow_nil?: false
      change manage_relationship(:campaign_id, :campaign, type: :append)
    end

    read :by_id do
      argument :id, :integer, allow_nil?: false
      get? true
      filter expr(id == ^arg(:id))
    end
  end

  attributes do
    integer_primary_key :id
    attribute :blob, :string
    attribute :column_names, {:array, string}
  end

  relationships do
    embeds_many :people, Vachan.Massmail.Person

    belongs_to :campaign, Vachan.Massmail.Campaign,
      attribute_writable?: true,
      attribute_type: :integer

    belongs_to :organization, Vachan.Organizations.Organization do
      domain(Vachan.Organizations)
    end
  end
end

defmodule Vachan.Massmail.Changes.ParseBlob do
  use Ash.Resource.Change

  @impl true
  def init(opts) do
    {:ok, opts}
  end

  @impl true
  def change(changeset, opts, _context) do
    case Ash.Changeset.fetch_change(changeset, opts[:attribute]) do
      {:ok, new_value} ->
        nil

      :error ->
        changeset
    end
  end
end

defmodule Vachan.Massmail.Person do
  use Ash.Resource,
    data_layer: :embedded

  attributes do
    attribute :email, :ci_string, allow_nil?: false, public?: true
    attribute :name, :string, allow_nil?: false, public?: true
    attribute :extras, :map
  end
end

defmodule Vachan.Calculations.ExtractColumnNames do
  use Ash.Resource.Calculation

  @impl true
  def init(opts) do
    {:ok, opts}
  end

  @impl true
  def load(_query, opts, _context) do
    opts[:keys]
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

  @impl true
  def calculate(records, opts, _params) do
    Enum.map(records, fn record ->
      List.flatten(
        Enum.map(opts[:keys], fn key -> List.first(csv_to_array(Map.get(record, key))) end)
      )
    end)
  end
end
