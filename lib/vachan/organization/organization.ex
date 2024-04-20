defmodule Vachan.Organization do
  use Ash.Api, otp_app: :vachan

  resources do
    resource Vachan.Organization.Tenant
  end
end
