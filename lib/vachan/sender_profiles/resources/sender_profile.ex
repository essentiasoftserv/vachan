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
  end

  actions do
    defaults [:read, :create, :update, :destroy]
    default_accept :*

    read :by_id do
      argument :id, :uuid, allow_nil?: false
      get? true
      filter expr(id == ^arg(:id))
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

    attribute :username, :string, allow_nil?: true, public?: true
    attribute :password, :string, allow_nil?: true, public?: true
    attribute :api_key, :string, allow_nil?: true, public?: true
    attribute :smtp_host, :string, allow_nil?: true, public?: true
    attribute :smtp_port, :string, allow_nil?: true, public?: true

    attribute :name, :string, allow_nil?: false, public?: true
    attribute :email, :ci_string, allow_nil?: false, public?: true

    attribute :title, :string, allow_nil?: false, public?: true
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
