defmodule Vachan.Organizations.Organization do
  use Ash.Resource,
    domain: Vachan.Organizations,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  policies do
    policy action_type(:update) do
      authorize_if relates_to_actor_via(:owner)
    end

    policy action_type(:create) do
      authorize_if always()
    end

    policy action_type(:read) do
      authorize_if always()
    end
  end

  code_interface do
    define :create, action: :create
    define :update, action: :update
    define :destroy, action: :destroy
    define :read_all, action: :read
    define :get_by_id, args: [:id], action: :by_id
    define :add_member, args: [:member_id, :role], action: :add_member
    define :remove_member, args: [:member_id, :role], action: :remove_member
    define :get_personal_org_for_user, args: [:member_id], action: :personal_org_for_user
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      accept [:name]
      primary? true
    end

    read :by_id do
      argument :id, :integer, allow_nil?: false
      get? true
      filter expr(id == ^arg(:id))
    end

    read :personal_org_for_user do
      argument :member_id, :uuid, allow_nil?: false
      get? true
      filter expr(name == "personal_" <> ^arg(:member_id))
    end

    update :add_member do
      argument :member_id, :uuid, allow_nil?: false
      argument :role, :atom, default: :member, allow_nil?: false
      require_atomic? false
      change manage_relationship(:member_id, :members, type: :append)
    end

    update :remove_member do
      argument :member_id, :uuid, allow_nil?: false
      change manage_relationship(:member_id, :members, type: :remove)
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      constraints max_length: 64
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  postgres do
    table "organizations"
    repo Vachan.Repo
  end

  relationships do
    has_many :members_join_assoc, Vachan.Organizations.Team

    many_to_many :members, Vachan.Accounts.User do
      through Vachan.Organizations.Team
      domain(Vachan.Accounts)
      source_attribute_on_join_resource :organization_id
      destination_attribute_on_join_resource :member_id
    end
  end
end
