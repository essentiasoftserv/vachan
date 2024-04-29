defmodule Vachan.SenderProfiles.SenderProfile do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

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
    define_for Vachan.SenderProfiles

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

  @provider_choices [:smtp, :sendgrid]
  attributes do
    uuid_primary_key :id

    attribute :provider, :atom do
      allow_nil? false
      constraints one_of: @provider_choices
      default :smtp
    end

    attribute :username, :string, allow_nil?: true
    attribute :password, :string, allow_nil?: true
    attribute :api_key, :string, allow_nil?: true
    attribute :smtp_host, :string, allow_nil?: true
    attribute :smtp_port, :string, allow_nil?: true

    attribute :name, :string, allow_nil?: false
    attribute :email, :ci_string, allow_nil?: false

    attribute :title, :string, allow_nil?: false
  end

  relationships do
    has_many :campaigns, Vachan.Massmail.Campaign do
      api Vachan.Massmail
    end

    belongs_to :organization, Vachan.Organizations.Organization do
      api Vachan.Organizations
    end
  end
end
