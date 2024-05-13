defmodule Vachan.Massmail.Workers.EnqueueEmails do
  use Oban.Worker,
    queue: :enqueue_emails

  alias Vachan.Massmail
  alias Vachan.Crm

  @impl true
  def perform(%Oban.Job{args: %{"campaign_id" => campaign_id} = _args}) do
    campaign =
      Massmail.Campaign.get_by_id!(campaign_id)
      |> Massmail.load!(:list)

    recepients = Crm.load!(campaign.list, :people)

    recepients.people
    |> Enum.map(
      &(Oban.Job.new(%{campaign_id: campaign_id, recepient_id: &1.id},
          queue: :hydrate_emails,
          worker: Vachan.Massmail.Workers.HydrateEmails
        )
        |> Oban.insert())
    )

    :ok
  end
end

defmodule Vachan.Massmail.Workers.HydrateEmails do
  use Oban.Worker,
    queue: :hydrate_emails

  alias Vachan.Massmail
  alias Vachan.Crm

  # @impl true
  # def perform(%Oban.Job{args: args}) do
  #   IO.inspect(args)
  # end

  @impl true
  def perform(%Oban.Job{
        args: %{"campaign_id" => campaign_id, "recepient_id" => recepient_id} = _args
      }) do
    campaign = Massmail.Campaign.get_by_id!(campaign_id)
    recepient = Crm.Person.get_by_id!(recepient_id)

    body = EEx.eval_string(campaign.text_body, person: recepient)
    subject = EEx.eval_string(campaign.subject, person: recepient)

    message =
      Massmail.Message.create!(%{
        campaign_id: campaign_id,
        recepient_id: recepient_id,
        status: :queued,
        subject: subject,
        body: body
      })

    Oban.Job.new(
      %{message_id: message.id},
      queue: :send_emails,
      worker: Vachan.Massmail.Workers.SendEmails
    )
    |> Oban.insert()

    :ok
  end
end

defmodule Vachan.Massmail.Workers.SendEmails do
  use Oban.Worker,
    queue: :send_emails

  import Swoosh.Email

  alias Vachan.Massmail
  alias Vachan.Crm

  @impl true
  def perform(%Oban.Job{args: %{"message_id" => message_id} = args}) do
    message =
      Massmail.Message.get_by_id!(message_id)
      |> Massmail.load!(:campaign)
      |> Massmail.load!(:recepient)

    campaign = message.campaign
    recepient = message.recepient

    email =
      new()
      |> from({campaign.sender_name, campaign.sender_email})
      |> to({recepient.name, recepient.email})
      |> subject(message.subject)
      |> html_body(message.body)
      |> text_body(message.body)

    case Vachan.Mailer.deliver(email) do
      {:ok, _} -> Massmail.Message.update!(message, %{status: :sent})
      {:error, _} -> Massmail.Message.update!(message, %{status: :failed})
    end
  end
end
