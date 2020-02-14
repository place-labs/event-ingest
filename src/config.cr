# Application dependencies
require "action-controller"
require "active-model"

running_in_production = ENV["SG_ENV"]? == "production"

# Logging configuration
ActionController::Logger.add_tag request_id
ActionController::Logger.add_tag client_ip

# Filter out sensitive params that shouldn't be logged
filter_params = ["password", "bearer_token"]
keeps_headers = ["X-Request-ID"]

# Default log levels
logger = ActionController::Base.settings.logger
logger.level = running_in_production ? Logger::INFO : Logger::DEBUG

# Application code
require "./controllers/application"
require "./controllers/*"
require "./models/*"

# Server required after application controllers
require "action-controller/server"

# Add handlers that should run before your application
ActionController::Server.before(
  ActionController::ErrorHandler.new(!running_in_production, keeps_headers),
  ActionController::LogHandler.new(filter_params),
  HTTP::CompressHandler.new
)

# InfluxDB connection
require "flux"
Flux.configure do |settings|
  settings.host = ENV["INFLUX_HOST"]? || abort "INFLUX_HOST env var not set"
  settings.api_key = ENV["INFLUX_API_KEY"]? || abort "INFLUX_API_KEY env var not set"
  settings.org = ENV["INFLUX_ORG"]? || "aca"
  settings.bucket = ENV["INFLUX_BUCKET"]? || "place"
  settings.logger = logger
end

# Tempory auth setup
# TODO: implement auth service with short-lived tokens.
API_KEY = ENV["PLACE_API_KEY"]? || abort "PLACE_API_KEY not set in ENV"

APP_NAME = "Place-API"
VERSION  = {{ `shards version #{__DIR__}`.chomp.stringify }}
