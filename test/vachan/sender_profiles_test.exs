defmodule Vachan.SenderProfilesTest do
  require Logger
  use Vachan.DataCase
  alias Vachan.SenderProfiles.SenderProfile

  import Vachan.AccountsFixtures

  describe "sender profiles" do
    @valid_attrs %{
      "title" => "title",
      "username" => "username",
      "password" => "password",
      "email" => "someone@something.com",
      "smtp_host" => "xyzyyz",
      "smtp_port" => "12345",
      "name" => "name",
    }

    @invalid_attrs %{
      "title" => nil,
      "username" => "",
      "password" => "short",
      "email" => "invalid_email",
      "smtp_host" => "",
      "smtp_port" => "invalid_port",
      "name" => nil,
    }
    @update_attrs %{
      "title" => "title2",
      "username" => "username1",
      "password" => "password1",
      "email" => "ssomeone@something.com",
      "smtp_host" => "xyzyyzs",
      "smtp_port" => "12378",
      "name" => "names",
    }

    test "should update sender_profile with valid attributes and owner user" do
      user = confirmed_user()
      tenant = user.orgs |> hd |> then(fn x -> x.id end)
      {:ok, sender_profile} = create_profile(@valid_attrs, user)
      {:ok, updated} = update_profile(sender_profile, @update_attrs, tenant, user)
      assert updated.title == @update_attrs["title"]

    end

    test "should not update sender_profile with invalid attributes and owner user" do
      user = confirmed_user()
      tenant = user.orgs |> hd |> then(fn x -> x.id end)
      {:ok, sender_profile} = create_profile(@valid_attrs, user)
      {:ok, updated} = update_profile(sender_profile,@update_attrs,tenant,user)
      assert updated.title == @update_attrs["title"]
    end
  end

  defp update_profile(profile, attrs, tenant, user) do
    profile
    |> Ash.Changeset.for_update(:update, attrs, actor: user, tenant: tenant)
    |> Ash.update()
  end

  defp create_profile(attrs, user) do
    Vachan.SenderProfiles.SenderProfile
    |> Ash.Changeset.for_create(:create, attrs, actor: user)
    |> Ash.create()
  end
end
defmodule Vachan.SenderProfilesTest do
  use Vachan.DataCase

  require Ash.Query
  require Logger

  import Vachan.AccountsFixtures

  alias Vachan.SenderProfiles

  @valid_attrs %{
    "title" => "Software Developer",
    "name" => "John Doe",
    "email" => "john.doe@example.com",
    "smtp_host" => "smtp.example.com",
    "smtp_port" => "587",
    "username" => "johndoe123",
    "password" => "securePassword123"
  }

  @invalid_attrs %{
    "title" => "",  # Invalid because it is empty (less than 1 character)
    "name" => "John123",  # Invalid because it contains numbers
    "email" => "john.doe@com",  # Invalid because the domain part is incorrect
    "smtp_host" => "smtp",  # Invalid because it is too short (less than 5 characters)
    "smtp_port" => "-85",  # Invalid because it is not a positive number
    "username" => "jo",  # Invalid because it is too short (less than 3 characters)
    "password" => "123"  # Invalid because it is too short (less than 6 characters)
  }

  @update_attrs %{
    "title" => "Senior Developer",
    "name" => "John Doe Jr",  # Updated name to meet validation: only letters and spaces
    "email" => "john.doe.jr@example.com",
    "smtp_host" => "smtp.updated.com",
    "smtp_port" => "465",
    "username" => "johnupdated",
    "password" => "newSecurePassword456"
  }

  describe "sender profile creation" do
    test "should create new sender profile with valid attributes" do
      user = confirmed_user()

      {:ok, profile} = create_sender_profile(@valid_attrs, user)
      assert profile.name == @valid_attrs["name"]
      assert to_string(profile.email) == @valid_attrs["email"]
      assert profile.username == @valid_attrs["username"]
      assert profile.password == @valid_attrs["password"]
      assert profile.smtp_host == @valid_attrs["smtp_host"]
      assert profile.smtp_port == @valid_attrs["smtp_port"]
      assert profile.title == @valid_attrs["title"]
    end

    test "should not create new sender profile with invalid attributes" do
      user = confirmed_user()
      assert {:error, _} = create_sender_profile(@invalid_attrs, user)
    end
  end

  describe "sender profile update" do
    test "should update sender_profile with valid attributes and owner user" do
      user = confirmed_user()
      tenant = user.orgs |> hd() |> then(& &1.id)
      {:ok, sender_profile} = create_sender_profile(@valid_attrs, user)

      case update_profile(sender_profile, @update_attrs, tenant, user) do
        {:ok, updated} ->
          assert updated.title == @update_attrs["title"]
          assert to_string(updated.email) == @update_attrs["email"]
          assert updated.smtp_host == @update_attrs["smtp_host"]
        {:error, %Ash.Error.Invalid{errors: errors}} ->
          flunk("Expected successful update but got validation errors: #{inspect(errors)}")
      end
    end

    test "should not update sender_profile with invalid attributes and owner user" do
      user = confirmed_user()
      tenant = user.orgs |> hd() |> then(& &1.id)
      {:ok, sender_profile} = create_sender_profile(@valid_attrs, user)

      assert {:error, _} = update_profile(sender_profile, @invalid_attrs, tenant, user)
    end
  end

  defp create_sender_profile(attrs, user) do
    SenderProfiles.SenderProfile
    |> Ash.Changeset.for_create(:create, attrs, actor: user)
    |> Ash.create()
  end

  defp update_profile(profile, attrs, tenant, user) do
    profile
    |> Ash.Changeset.for_update(:update, attrs, actor: user, tenant: tenant)
    |> Ash.update()
  end
end
