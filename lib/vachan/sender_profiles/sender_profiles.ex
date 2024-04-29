defmodule Vachan.SenderProfiles do
  use Ash.Api

  resources do
    resource(Vachan.SenderProfiles.SenderProfile)
  end

  authorization do
    require_actor? true
    authorize :by_default
  end
end
