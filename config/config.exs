# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :fire_sale,
  ecto_repos: [FireSale.Repo],
  generators: [timestamp_type: :utc_datetime]

# Keep Oban jobs for 3 months so I can inspect them
three_months_in_seconds = 7_776_000

config :fire_sale, Oban,
  engine: Oban.Engines.Basic,
  plugins: [{Oban.Plugins.Pruner, max_age: three_months_in_seconds}],
  queues: [default: 1],
  repo: FireSale.Repo

config :fire_sale, :email, System.get_env("SYSTEM_EMAIL") || "hi@bpaulino.com"

# Configures the endpoint
config :fire_sale, FireSaleWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: FireSaleWeb.ErrorHTML, json: FireSaleWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: FireSale.PubSub,
  live_view: [signing_salt: "prT9wJ9Z"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :fire_sale, FireSale.Mailer, adapter: Swoosh.Adapters.Local

# by default, use the priv directory for product images.
# overwrite this in other environments if you want
# to use the directory `/var/product_images` instead
config :fire_sale, :use_priv_for_images, true

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  fire_sale: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  fire_sale: [
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

config :fire_sale, :chat_notifier, FireSale.Notification.LocalNotifier

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
