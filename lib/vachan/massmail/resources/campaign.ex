defmodule Vachan.Massmail.Campaign do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  resource do
    description "Campaigns are used to send mass emails to a list of recipients."
  end

  @possible_status [:draft, :scheduled, :sending, :sent, :paused, :cancelled, :failed]

  postgres do
    table "campaigns"
    repo Vachan.Repo
  end

  multitenancy do
    strategy :attribute
    attribute :organization_id
  end

  code_interface do
    define_for Vachan.Massmail

    define :destroy, action: :destroy
    define :read_all, action: :read
    define :get_by_id, args: [:id], action: :by_id
    define :list, action: :list
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      primary? true

      accept [
        :name,
        :reply_to_email,
        :reply_to_name,
        :subject,
        :text_body,
        :status
      ]

      argument :list_id, :integer do
        allow_nil? false
      end

      change manage_relationship(:list_id, :list, type: :append)
    end

    update :update do
      primary? true

      accept [
        :name,
        :subject,
        :text_body
      ]

      argument :list_id, :integer do
        allow_nil? false
      end

      change manage_relationship(:list_id, :list, type: :append)
    end

    read :by_id do
      argument :id, :integer, allow_nil?: false
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
    integer_primary_key :id

    attribute :name, :string, allow_nil?: false

    attribute :reply_to_email, :string, allow_nil?: true
    attribute :reply_to_name, :string, allow_nil?: true

    attribute :subject, :string, allow_nil?: false
    attribute :text_body, :string, allow_nil?: false

    attribute :status, :atom do
      allow_nil? false
      default :draft
      constraints one_of: @possible_status
    end

    attribute :active, :boolean, allow_nil?: false, default: true

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    has_many :messages, Vachan.Massmail.Message
    belongs_to :list, Vachan.Crm.List, api: Vachan.Crm, attribute_type: :integer

    belongs_to :organization, Vachan.Organizations.Organization do
      api Vachan.Organizations
    end

    belongs_to :sender_profile, Vachan.SenderProfiles.SenderProfile do
      api Vachan.SenderProfiles
    end
  end

  validations do
    validate match(:sender_email, ~r/^[^\s]+@[^\s]+$/),
      on: [:create, :update],
      message: "Invalid email"
  end
end
