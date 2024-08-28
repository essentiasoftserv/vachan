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

    @update_attrs %{
      "title" => "title2",
      "username" => "username1",
      "password" => "password1",
      "email" => "ssomeone@something.com",
      "smtp_host" => "xyzyyzs",
      "smtp_port" => "12378",
      "name" => "names",
    }

    test "should not update sender_profile with invalid attributes and owner user" do
      user = confirmed_user()
      tenant = user.orgs |> hd |> then(fn x -> x.id end)
      {:ok, sender_profile} = create_profile(@valid_attrs, user)
      {:ok, updated} = update_profile(sender_profile,@update_attrs,tenant,user)
      assert updated.title == @update_attrs["title"]

    end
  end

  defp update_profile(profiles,attrs,tenant,user) do
    profiles
    |> Ash.Changeset.for_update(:update, attrs, actor: user,tenant: tenant)
    |> Ash.update()
  end

  defp create_profile(attrs,user) do
      Vachan.SenderProfiles.SenderProfile
      |> Ash.Changeset.for_create(:create, attrs, actor: user)
      |> Ash.create()
  end
end
