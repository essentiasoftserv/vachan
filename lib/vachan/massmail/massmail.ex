defmodule Vachan.Massmail do
  use Ash.Api

  resources do
    resource Vachan.Massmail.Campaign
    resource Vachan.Massmail.Message
    resource Vachan.Massmail.Template
    resource Vachan.Massmail.Event
    resource Vachan.Massmail.Content
    resource Vachan.Massmail.Recepients
  end

  authorization do
    require_actor? true
    authorize :by_default
  end
end
