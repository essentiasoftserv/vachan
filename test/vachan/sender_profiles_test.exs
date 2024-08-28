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
    "password" => "securePassword123",
    "api_key" => "abcdefghij1234567890",
  }

  @invalid_attrs %{
      "title" => "",  # Invalid because it is empty (less than 1 character)
      "name" => "John123",  # Invalid because it contains numbers
      "email" => "john.doe@com",  # Invalid because the domain part is incorrect
      "smtp_host" => "smtp",  # Invalid because it is too short (less than 5 characters)
      "smtp_port" => "-85",  # Invalid because it is not a number
      "username" => "jo",  # Invalid because it is too short (less than 3 characters)
      "password" => "123",  # Invalid because it is too short (less than 6 characters)
      "api_key" => "abcdefghijk123",  # Invalid because it is too short (less than 10 characters)
  }


   describe "sender profile creation" do

    test "should create new sender profile with valid attributes "do
      user = confirmed_user()

      profile = create_sender_profile(@valid_attrs, user)
      assert profile.name == "John Doe"
      assert to_string(profile.email) == "john.doe@example.com"
      assert profile.username == "johndoe123"
      assert profile.password == "securePassword123"
      assert profile.smtp_host == "smtp.example.com"
      assert profile.smtp_port == "587"
      assert profile.title == "Software Developer"
      assert profile.api_key == "abcdefghij1234567890"
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

 # validations do
   # validate match(:email, ~r/^[\w.%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/), where: [changing(:email)], message: "Must be a valid email"
   # validate match(:username, ~r/^.{3,100}$/), where: [changing(:username)], message: "Username must be between 3 and 100 characters"
    #validate match(:password, ~r/^.{6,100}$/), where: [changing(:password)], message: "Password must be between 6 and 100 characters"
   # validate match(:api_key, ~r/^.{10,100}$/), where: [changing(:api_key)], message: "API key must be between 10 and 100 characters"
   #validate match(:smtp_host, ~r/^.{5,100}$/), where: [changing(:smtp_host)], message: "SMTP host must be between 5 and 100 characters"
   # validate match(:smtp_port, ~r/^\d+$/), where: [changing(:smtp_port)], message: "SMTP port must be a valid number"
   # validate match(:name, ~r/^[a-zA-Z\s]+$/), where: [changing(:name)], message: "Name must contain only letters and spaces"
   # validate match(:title, ~r/^.{1,100}$/), where: [changing(:title)], message: "Title must be between 1 and 100 characters"
