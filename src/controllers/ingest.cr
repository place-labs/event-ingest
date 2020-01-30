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
    # InfluxDB stores points based on a unique keying of time, measure and tag
    # values. If multiple points share these they will be overwritten. This
    # occurs when events are sourced from an input with course time granularity
    # (e.g. a bulk import of manually entered data - think observations at
    # 9:30am). To enable pivoting to restore original associations for all
    # fields in a point, introduce a 20 bits of noise (< 1.05ms) to the
    # timestamp as a hash of the location identifier.
    loc_hash = event.location.hash
    loc_hash >>= 4
    noise = (loc_hash ^ (loc_hash >> 20) ^ (loc_hash >> 40)) & 0xfffff
    ts = event.time + noise.nanoseconds

    point = InfluxDB::Point.new! event.type, ts, **event.fields
    point.tag **event.tags

    Flux.write point
  end
end
