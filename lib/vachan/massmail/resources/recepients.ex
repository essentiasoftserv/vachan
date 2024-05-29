defmodule Vachan.Massmail.Recepients do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

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
    define_for Vachan.Massmail

    define :create, action: :create
    define :destroy, action: :destroy
    define :read_all, action: :read
    define :get_by_id, args: [:id], action: :by_id
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      primary? true

      accept [
        :blob
      ]

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
  end

  relationships do
    belongs_to :campaign, Vachan.Massmail.Campaign,
      attribute_writable?: true,
      attribute_type: :integer

    belongs_to :organization, Vachan.Organizations.Organization do
      api Vachan.Organizations
    end
  end
end
