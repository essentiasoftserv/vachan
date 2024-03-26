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

  code_interface do
    define_for Vachan.Massmail

    define :create, action: :create
    define :update, action: :update
    define :destroy, action: :destroy
    define :read_all, action: :read
    define :get_by_id, args: [:id], action: :by_id
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    read :by_id do
      argument :id, :integer, allow_nil?: false
      get? true
      filter expr(id == ^arg(:id))
    end
  end

  attributes do
    integer_primary_key :id

    attribute :name, :string, allow_nil?: false

    attribute :sender_name, :string, allow_nil?: false
    attribute :sender_email, :string, allow_nil?: false
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
  end

  validations do
    validate match(:sender_email, ~r/^[^\s]+@[^\s]+$/),
      on: [:create, :update],
      message: "Invalid email"
  end
end
