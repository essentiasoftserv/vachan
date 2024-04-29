defmodule Vachan.Crm.Person do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    notifiers: [Ash.Notifier.PubSub]

  resource do
    description "A person is a contact in the CRM system."
  end

  postgres do
    table "people"
    repo Vachan.Repo
  end

  multitenancy do
    strategy :attribute
    attribute :organization_id
  end

  pub_sub do
    module VachanWeb.Endpoint
    prefix "person"
    broadcast_type :phoenix_broadcast

    publish :create, ["created"]
    publish :update, ["updated"]
    publish :destroy, ["destroyed"]
  end

  code_interface do
    define_for Vachan.Crm

    define :create, action: :create
    define :update, action: :update
    define :destroy, action: :destroy
    define :read_all, action: :read
    define :get_by_id, args: [:id], action: :by_id
    define :list, action: :list
  end

  actions do
    defaults [:read, :create, :update, :destroy]

    read :by_id do
      argument :id, :uuid, allow_nil?: false
      get? true
      filter expr(id == ^arg(:id))
    end

    read :list do
      pagination do
        default_limit 50
        offset? true
        countable :by_default
      end
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :first_name, :string, allow_nil?: false
    attribute :last_name, :string, allow_nil?: false

    attribute :email, :ci_string do
      allow_nil? false

      constraints match: ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
    end

    attribute :phone, :string do
      allow_nil? true
    end

    attribute :city, :string do
      allow_nil? true
    end

    attribute :state, :string do
      allow_nil? true
    end

    attribute :country, :string do
      allow_nil? true
    end

    attribute :designation, :string do
      allow_nil? true
    end

    attribute :company, :string do
      allow_nil? true
    end

    # TODO: make this a jsonb field, validated against a list of tags in a separate table.
    attribute :tags, :string do
      allow_nil? true
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  identities do
    identity :unique_email, [:email]
  end

  relationships do
    many_to_many :lists, Vachan.Crm.List do
      through Vachan.Crm.PersonList
      source_attribute_on_join_resource :person_id
      destination_attribute_on_join_resource :list_id
    end

    belongs_to :organization, Vachan.Organizations.Organization do
      api Vachan.Organizations
    end
  end
end
