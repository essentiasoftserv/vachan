defmodule Vachan.ListTest do
  require Logger
  use Vachan.DataCase
  alias Vachan.Crm

  @valid_attrs %{
    "name" => "test_new_list"
  }

  @update_attrs %{
    "name" => "update_new_list"
  }

  @invalid_attrs %{
    "name" => ""
  }

  # @already_taken_attrs %{
  #   "message" => "has already been taken"
  # }

  describe "Test-1: create list" do
    test "list should be created with valid attributes" do
      list = create_list(@valid_attrs, :no_user)
      assert list.name == @valid_attrs["name"]
    end

    # test "list cannot create with present list name " do
    #   list = create_list(@valid_attrs, :no_user)
    #   assert list.name == @valid_attrs["name"]
    #   IO.inspect(list)
    #   assert_raise Ash.Error.Invalid, fn ->
    #       create_list(@valid_attrs, :no_user)
    #     end
    # end
  end

  describe "Test-2: read and display list detail" do
    test "to read all list" do
      create_list(@valid_attrs, :no_user)
      lists = Crm.List.read_all!(actor: :no_user)
      assert Enum.count(lists) == 1
    end

    test "to show list deatails by list id" do
      lists = create_list(@valid_attrs, :no_user)
      get_by_id = get_list_by_id(lists.id, :no_user)
      assert get_by_id.name == lists.name
    end
  end

  describe "Test-3: update list" do
    test "update list with valid attributes" do
      list = create_list(@valid_attrs, :no_user)
      update_list = update_list(list, @update_attrs, :no_user)
      assert update_list.name == @update_attrs["name"]
    end
  end

  describe "Test-4: destroy list" do
    test "to successfully delete an item from the list" do
      list_id = create_list(@valid_attrs, :no_user)
      delete_by_id = destroy_list(list_id.id, :no_user)
      assert :ok == delete_by_id
    end
  end

  defp create_list(attrs, user) do
    {:ok, list} =
      Crm.List
      |> Ash.Changeset.for_create(:create, attrs)
      |> Crm.create()

    list
  end

  defp update_list(list, attrs, user) do
    list
    |> Ash.Changeset.for_update(:update, attrs)
    |> Crm.update!()
  end

  defp get_list_by_id(id, user) do
    Crm.List
    |> Crm.get!(id, actor: user)
  end

  defp destroy_list(id, user) do
    Crm.List
    |> Crm.get!(id, actor: user)
    |> Crm.destroy!()
  end
end
