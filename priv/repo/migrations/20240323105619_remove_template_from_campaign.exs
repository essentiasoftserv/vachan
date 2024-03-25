defmodule Vachan.Repo.Migrations.RemoveTemplateFromCampaign do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    # alter table(:templates) do
    # Attribute removal has been commented out to avoid data loss. See the migration generator documentation for more
    # If you uncomment this, be sure to also uncomment the corresponding attribute *addition* in the `down` migration
    # remove :campaign_id
    # end
    # 
    alter table(:campaigns) do
      add :subject, :text, null: false
      add :text_body, :text, null: false
    end
  end

  def down do
    alter table(:campaigns) do
      remove :text_body
      remove :subject
    end

    # alter table(:templates) do
    # This is the `down` migration of the statement:
    #
    #     remove :campaign_id
    #
    # 
    # add :campaign_id, references(:campaigns, column: :id, name: "templates_campaign_id_fkey", type: :bigint, prefix: "public")
    # end
    # 
  end
end