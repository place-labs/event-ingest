require "json"

# PlaceAPI event stream message.
# TODO move to a standalone lib
struct PlaceAPI::Event
  include JSON::Serializable

  # Event type.
  @[JSON::Field(key: "evt")]
  getter type : String

  # Unix timestamp of event occurance.
  @[JSON::Field(key: "uts", converter: Time::EpochConverter)]
  getter timestamp : Time

  # A globally unique identifier for the originating organisation.
  @[JSON::Field(key: "org")]
  getter organisation : String

  # A globally unique identifier for the originating building.
  @[JSON::Field(key: "bld")]
  getter building : String

  # A globally unique identifier for the originating level.
  @[JSON::Field(key: "lvl")]
  getter level : String

  # A globally unique identifier for the originating location.
  @[JSON::Field(key: "loc")]
  getter location : String

  # The originating event source type / module class.
  @[JSON::Field(key: "src")]
  getter source : String

  # The originating module identifier.
  @[JSON::Field(key: "mod", emit_null: true)]
  getter module_id : String?

  # Event value. Generally associated state information.
  @[JSON::Field(key: "val")]
  getter value : Float64

  # Event reference. Supplementry info supporting the event value.
  @[JSON::Field(key: "ref", emit_null: true)]
  getter reference : String?

  # Curator chain. A dot seperated list of curator ID's used in the event's
  # propogation path.
  @[JSON::Field(key: "cur", emit_null: true)]
  getter curator : String?

  # Provides the set of event attributes that are suitable for indexing.
  def tags
    {
      org: organisation,
      bld: building,
      lvl: level,
      src: source
    }
  end

  # Provides the set of event attributes that should not be indexed due to high
  # cardinality.
  def fields
    {
      loc: location,
      mod: module_id,
      val: value,
      ref: reference,
      cur: curator
    }
  end
end
