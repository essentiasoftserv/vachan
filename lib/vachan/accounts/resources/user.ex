defmodule Vachan.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  actions do
    defaults [:read]
  end

  authentication do
    api Vachan.Accounts

    add_ons do
      confirmation :confirm do
        monitor_fields([:email])
        sender(Vachan.Accounts.Senders.SendEmailConfirmationEmail)
      end
    end

    strategies do
      password :password do
        identity_field :email
        sign_in_tokens_enabled? true

        resettable do
          sender(Vachan.Accounts.Senders.SendPasswordResetEmail)
        end
      end
    end

    tokens do
      enabled? true
      token_resource Vachan.Accounts.Token

      signing_secret Vachan.Accounts.Secrets
    end
  end

  postgres do
    table "users"
    repo Vachan.Repo
  end

  identities do
    identity :unique_email, [:email] do
    eager_check_with Vachan.Accounts
    end
  end

  validations do
    validate match(:email, ~r/^[^\s]+@[^\s]+$/), on: [:create, :update], message: "invalid email"
  end

  relationships do
    belongs_to :tenant, Vachan.Organization.Tenant, api: Vachan.Organization

    has_one :profile, Vachan.Profiles.Profile do
      api Vachan.Profiles
      source_attribute :id
      destination_attribute :id
    end
  end

  # If using policies, add the following bypass:
  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end
  # end
end
