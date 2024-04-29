# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :vachan,
  ash_apis: [
    Vachan.Accounts,
    Vachan.Crm,
    Vachan.Massmail,
    Vachan.Prelaunch,
    Vachan.Organizations,
    Vachan.Profiles,
    Vachan.SenderProfiles
  ]

config :ash, :compatible_foreign_key_types, [
  {Ash.Type.UUID, Ash.Type.Integer}
]

config :vachan, Oban,
  repo: Vachan.Repo,
  queues: [default: 10, enqueue_emails: 2, hydrate_emails: 2, send_emails: 2]

config :vachan,
  ecto_repos: [Vachan.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :vachan, VachanWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: VachanWeb.ErrorHTML, json: VachanWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Vachan.PubSub,
  live_view: [signing_salt: "qq0u3lZ0"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :vachan, Vachan.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  vachan: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  vachan: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
