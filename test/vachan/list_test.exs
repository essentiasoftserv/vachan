defmodule Vachan.ListTest do
  require Logger
  use Vachan.DataCase
  alias Vachan.Crm

  import Vachan.AccountsFixtures

  describe "list creation" do
    @valid_attrs %{
      "name" => "test_new_list"
    }

    @update_attrs %{
      "name" => "test_update_list"
    }

    @invalid_attrs %{
      "name" => "not_a_list"
    }

    test "Test-1: list should be created with valid attributes" do
      user = confirmed_user()
      list = create_list(@valid_attrs, user)
      assert list.name == @valid_attrs["name"]
    end

    test "Test-2: list should be created with invalid attributes" do
      user = confirmed_user()
      invalid_list = create_list(@invalid_attrs, user)
      assert invalid_list.name == @invalid_attrs["name"]
    end

    test "Test-3: list should be updated with valid attributes" do
      user = confirmed_user()
      tenant = user.orgs |> hd |> then(fn x -> x.id end)
      list = create_list(@valid_attrs, user)
      {:ok, updated_list} = update_list(list, @update_attrs, user, tenant)
      assert updated_list.name == @update_attrs["name"]
    end
  end

  test "Test-4: list should be updated with invalid attributes" do
    user = confirmed_user()
    tenant = user.orgs |> hd |> then(fn x -> x.id end)
    invalid_list = create_list(@valid_attrs, user)
    err_attrs = update_list(invalid_list, @invalid_attrs, user, tenant)
  end

  defp create_list(attrs, user) do
    {:ok, list} =
      Crm.List
      |> Ash.Changeset.for_create(:create, attrs, actor: user)
      |> Crm.create()

    list
  end

  defp update_list(list, attrs, user, tenant) do
    list
    |> Ash.Changeset.for_update(:update, attrs, actor: user, tenant: tenant)
    |> Crm.update()
  end
end
