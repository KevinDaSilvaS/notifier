import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :notifier, NotifierWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "3Om9OvfFj52KLIocCgofeIEETLjcBaUqZox5ENSQ7vEOkDf0x62iK+nuQn/NrVnG",
  server: false

# In test we don't send emails.
config :notifier, Notifier.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
