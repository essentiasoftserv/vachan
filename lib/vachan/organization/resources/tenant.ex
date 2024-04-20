defmodule Vachan.Organization.Tenant do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  resource do
    description "Tenants are the organizations that use the system."
  end

  postgres do
    table "tenants"
    repo Vachan.Repo
  end

  code_interface do
    define_for Vachan.Organization

    define :create, action: :create
    define :update, action: :update
    define :destroy, action: :destroy
    define :read_all, action: :read
    define :get_by_id, args: [:id], action: :by_id
  end

  actions do
    defaults [:read, :update, :destroy]

    read :by_id do
      argument :id, :uuid, allow_nil?: false
      get? true
      filter expr(id == ^arg(:id))
    end

    create :create do
      accept [:name, :subdomain]
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string, allow_nil?: false
    attribute :subdomain, :string, allow_nil?: false
    attribute :created_at, :utc_datetime, allow_nil?: false
    attribute :updated_at, :utc_datetime, allow_nil?: false
  end

  relationships do
    has_many :users, Vachan.Accounts.User, api: Vachan.Accounts
  end

  identities do
    identity :unique_subdomain, [:subdomain]
  end
end
