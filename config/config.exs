# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :my_app,
  generators: [binary_id: true]

# Configures the endpoint
config :my_app, MyAppWeb.Endpoint,
  url: [host: "localhost", scheme: "http"],
  secret_key_base: "HLxW7xe3VkSAKty2Tkncnlo8mty9Q+N70xB+1wx8/55HD938y+IZ7yA5XSHOmlqe",
  render_errors: [view: MyAppWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: MyApp.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Swagger
config :my_app, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      # phoenix routes will be converted to swagger paths
      router: MyAppWeb.Router,
      # (optional) endpoint config used to set host, port and https schemes.
      endpoint: MyAppWeb.Endpoint
    ]
  }

# protobuf
config :phoenix, :format_encoders, proto: MyAppWeb.ProtoFormatEncoder
config :mime, :types, %{
  "application/x-proto" => ["proto"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
