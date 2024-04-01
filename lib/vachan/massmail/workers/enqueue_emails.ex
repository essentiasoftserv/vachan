defmodule Vachan.Massmail.Workers.EnqueueEmails do
  use Oban.Worker,
    queue: :enqueue_emails,
    max_attempts: 3,
    max_age: 1_800,
    max_errors: 3

  alias Vachan.Massmail
  alias Vachan.Crm

  @impl true
  def perform(%Oban.Job{args: args}) do
    campaign_id = Keyword.fetch!(args, :campaign_id)
    campaign = Massmail.Campaign.get_by_id!(campaign_id)

    recepient_list = Massmail.load!(campaign, :list)
    recepients = Crm.load!(recepient_list, :people)

    recepients
    |> Enum.map(
      &Massmail.Message.create!(%{
        campaign_id: campaign_id,
        recepient_id: &1.id,
        status: :queued
      })
    )

    :ok
  end
end

defmodule Vachan.Massmail.Workers.SendEmails do
  use Oban.Worker,
    queue: :send_mails,
    max_attempts: 3,
    max_age: 1_800,
    max_errors: 3

  alias Vachan.Massmail

  @impl true
  def perform(%Oban.Job{args: args}) do
    message_id = Keyword.fetch!(args, :message_id)
    message = Massmail.Message.get_by_id!(message_id)

    case Massmail.send_email(message) do
      {:ok, _} -> Massmail.Message.update!(message, %{status: :sent})
      {:error, _} -> Massmail.Message.update!(message, %{status: :failed})
    end
  end
end
