defmodule Vachan.SenderProfiles.SenderProfile do
  use Ash.Resource, domain: Vachan.SenderProfiles, data_layer: AshPostgres.DataLayer

  resource do
    description "The place for users to store the configuration params for their email gateways."
  end

  postgres do
    table "sender_profiles"
    repo Vachan.Repo
  end

  multitenancy do
    strategy :attribute
    attribute :organization_id
  end

  code_interface do
    define :create, action: :create
    define :update, action: :update
    define :destroy, action: :destroy
    define :read_all, action: :read
    define :get_by_id, args: [:id], action: :by_id
    define :list, action: :list
  end

  actions do
    defaults [:read, :create, :update, :destroy]
    default_accept :*

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

  @provider_choices [:smtp, :sendgrid]
  attributes do
    uuid_primary_key :id

    attribute :provider, :atom do
      allow_nil? false
      constraints one_of: @provider_choices
      default :smtp
    end

    attribute :username, :string do
      allow_nil? false
      public? true
      constraints min_length: 3, max_length: 100
    end

    attribute :password, :string do
      allow_nil? false
      public? true
      constraints min_length: 6, max_length: 100
    end

    attribute :api_key, :string do
      allow_nil? true
      public? true
      constraints min_length: 10,
                  max_length: 100
    end

    attribute :smtp_host, :string do
      allow_nil? false
      public? true
      constraints min_length: 5,
                  max_length: 100
    end

    attribute :smtp_port, :string do
      allow_nil? true
      public? true
      constraints match: ~r/^\d+$/
    end

    attribute :name, :string do
      allow_nil? false
      public? true
      constraints [
        min_length: 1, max_length: 100,
        match: ~r/^[a-zA-Z\s]+$/,
      ]
    end

    attribute :email, :ci_string do
      allow_nil? false
      public? true
      constraints match: ~r/^[\w.%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
    end

    attribute :title, :string do
      allow_nil? false
      public? true
      constraints min_length: 1, max_length: 100
    end
  end

  identities do
    identity :unique_name, [:title]
  end

  relationships do
    has_many :campaigns, Vachan.Massmail.Campaign do
      domain(Vachan.Massmail)
    end

    belongs_to :organization, Vachan.Organizations.Organization do
      domain(Vachan.Organizations)
    end
  end
end
