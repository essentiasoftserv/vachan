defmodule Vachan.Repo.Migrations.Prelaunch do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:messages) do
      modify :status, :text, default: "created"
    end
  end

  def down do
    alter table(:messages) do
      modify :status, :text, default: nil
    end
  end
end
