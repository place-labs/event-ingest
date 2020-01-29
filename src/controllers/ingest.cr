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
    # Insert up to 0.1ms of noise to each point. Events are stored based on a
    # unique keying of time and associated tag set. There are cases where
    # multiple events may occur within the same millisecond (particularly from
    # sources only supporting course time granularity on the original event -
    # e.g. a bulk import of manually entered data), resulting in overwritten
    # value. This de-dups and also provide unique timestamps that can be used to
    # pivot and restor original point associations across fields.
    ts = event.time + Random.rand(1e5).nanoseconds

    point = InfluxDB::Point.new! event.type, ts, **event.fields
    point.tag **event.tags
    Flux.write point
  end
end
