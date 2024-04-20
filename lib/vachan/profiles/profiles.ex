defmodule Vachan.Profiles do
  use Ash.Api

  resources do
    resource Vachan.Profiles.Profile
  end

  authorization do
    require_actor? true
    authorize :by_default
  end
end
