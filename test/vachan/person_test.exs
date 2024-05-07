defmodule Vachan.PersonTest do
  require Logger
  use Vachan.DataCase
  alias Vachan.Crm

  import Vachan.AccountsFixtures

  describe "person creation" do
    @valid_attrs %{
      "email" => "someone@something.com",
      "first_name" => "Some",
      "last_name" => "One"
    }

    @update_attrs %{
      "email" => "anotherone@somethingelse.com",
      "first_name" => "Another",
      "last_name" => "One"
    }

    @invalid_attrs %{
      "email" => "notanemail",
      "first_name" => "Not",
      "last_name" => "AnEmail"
    }

    test "should be created with valid attributes" do
      user = confirmed_user()
      {:ok, person} = create_person(@valid_attrs, user)

      assert person.first_name == @valid_attrs["first_name"]
      assert person.last_name == @valid_attrs["last_name"]
      assert person.email |> to_string == @valid_attrs["email"]
    end

    test "should not be created with invalid attributes" do
      user = confirmed_user()
      {:error, err} = create_person(@invalid_attrs, user)
    end
  end

  test "should be updated with valid attributes" do
    user=confirmed_user()
    tenant = user.orgs |> hd |> then(fn x -> x.id end)
    {:ok, person} = create_person(@valid_attrs, user)
    {:ok,updated} = update_person(person, @update_attrs, user, tenant)
    assert updated.first_name == @update_attrs["first_name"]
    assert updated.last_name == @update_attrs["last_name"]
    assert updated.email |> to_string == @update_attrs["email"]

  end

  test "should not be updated with invalid attributes" do
    user=confirmed_user()
    {:error, err} = update_person(@invalid_attrs, user, tenant)
  end


  defp update_person(person, attrs, user, tenant)do
   person
   |> Ash.Changeset.for_update(:update, attrs, actor: user, tenant: tenant )
   |> Crm.update()
  end

  defp create_person(attrs, user) do
    Crm.Person
    |> Ash.Changeset.for_create(:create, attrs, actor: user)
    |> Crm.create()
  end
end
