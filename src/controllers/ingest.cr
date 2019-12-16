require "flux"
require "../place_api/event"

class Ingest < Application
  base "/ingest"

  # Accepts Place API event stream objects as JSON lines within the event body.
  post "/", :batch_ingest do
    body = request.body
    if body
      body.each_line &->ingest(String)
      head :accepted
    else
      head :bad_request
    end
  end

  # Accepts a stream of Place API events. Each message should contain a singular
  # event for storage.
  ws "/", :stream_ingest do |socket|
    socket.on_message &->ingest(String)
  end

  # Parses a received event and stores it.
  private def ingest(event : String) : Nil
    store PlaceAPI::Event.from_json event
  rescue ex : JSON::ParseException
    logger.warn { "invalid event format: #{event}"}
  end

  # Saves an event.
  private def store(event : PlaceAPI::Event)
    point = InfluxDB::Point[event.type, event.timestamp, **event.fields]
    point.tag **event.tags
    Flux.write point
  end
end
