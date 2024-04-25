defmodule Vachan.CrmFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vachan.Crm` context.
  """

  @doc """
  Generate a person record for testing.
  """
  def person_fixture(attrs \\ %{}) do
    person_attrs =
      attrs
      |> Enum.into(%{
        email: "whoisit@gmail.com",
        first_name: "Who",
        last_name: "Isit",
        phone: "199393930"
      })

    {:ok, person} =
      Vachan.Crm.Person
      |> Ash.Changeset.for_create(:create, person_attrs)
      |> Vachan.Crm.create()

    person
  end

  @doc """
  Generate a list record for testing.
  """
  def list_fixture(attrs \\ %{}) do
    list_attrs =
      attrs
      |> Enum.into(%{
        name: "new_list"
      })

    {:ok, list} =
      Vachan.Crm.List
      |> Ash.Changeset.for_create(:create, list_attrs)
      |> Vachan.Crm.create()

    list
  end
end
