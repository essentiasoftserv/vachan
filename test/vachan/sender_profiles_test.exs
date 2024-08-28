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
      "smtp_port" => "-85",  # Invalid because it is not a number
      "username" => "jo",  # Invalid because it is too short (less than 3 characters)
      "password" => "123",  # Invalid because it is too short (less than 6 characters)
  }

  describe "sender profile creation" do
    test "should create new sender profile with valid attributes " do
      user = confirmed_user()

      profile = create_sender_profile(@valid_attrs, user)
      assert profile.name == @valid_attrs["name"]
      assert to_string(profile.email) == @valid_attrs["email"]
      assert profile.username == @valid_attrs["username"]
      assert profile.password == @valid_attrs["password"]
      assert profile.smtp_host == @valid_attrs["smtp_host"]
      assert profile.smtp_port == @valid_attrs["smtp_port"]
      assert profile.title == @valid_attrs["title"]
    end

    test "should not create new sender profile with invalid attributes " do
      user = confirmed_user()
      assert_raise Ash.Error.Invalid, fn -> create_sender_profile(@invalid_attrs, user) end
    end
  end

  defp create_sender_profile(attrs, user) do
    SenderProfiles.SenderProfile
    |> Ash.Changeset.for_create(:create, attrs, actor: user)
    |> Ash.create!()
  end
end
