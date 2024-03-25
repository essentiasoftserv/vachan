defmodule Vachan.Massmail.Template do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  resource do
    description "Templates are used to create messages for mass emails."
  end

  postgres do
    table "templates"
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
    attribute :subject, :string, allow_nil?: false
    attribute :text_body, :string, allow_nil?: false
    attribute :html_body, :string, allow_nil?: false

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
  end
end
