class Level < Application
  base "/level"

  module Window
    record Instant, at : Time

    record Range, from : Time, to : Time do
      def total_seconds
        (to - from).total_seconds
      end
    end

    record Aggregate, from : Time, to : Time, at : Time do
      def total_seconds
        (to - from).total_seconds
      end
    end

    def self.from(params)
      from = params["from"]?.try { |t| Time.unix_ms t.to_i64 }
      to = params["to"]?.try { |t| Time.unix_ms t.to_i64 }
      at = params["at"]?.try { |t| Time.unix_ms t.to_i64 }

      if from && to && at
        Aggregate.new from, to, at
      elsif from && to
        Range.new from, to
      elsif at
        Instant.new at
      end
    end
  end

  # Tempory endpoint for providing aggregated presence stats.
  get "/:id/presence" do
    level = params["id"]
    include_locations = params["include_locations"]? == "true"
    window = Window.from(params) || Window::Instant.new(Time.utc)

    response = { event: "presence" }

    case window
    when Window::Instant
      logger.warn "specific time queries not implemented"
      head :not_implemented
    when Window::Range
      query = <<-FLUX
        import "math"
        presenceEvents = from(bucket: "place")
          |> range(start: #{window.from.to_rfc3339}, stop: #{window.to.to_rfc3339})
          |> filter(fn: (r) => r._measurement == "presence")
          |> filter(fn: (r) => r.lvl == "#{level}")
          |> pivot(rowKey: ["_time", "lvl", "src"], columnKey: ["_field"], valueColumn: "_value")
          |> group(columns: ["loc", "lvl", "bld", "org"])
        shifted = presenceEvents
          |> timeShift(duration: -1ns)
          |> drop(columns: ["val"])
        union(tables: [presenceEvents, shifted])
          |> sort(columns: ["_time"])
          |> fill(column: "val", usePrevious: true)
          |> integral(unit: 1s, column: "val")
          |> group(columns: ["lvl"])
          |> map(fn: (r) => ({r with val: r.val / #{window.total_seconds}}))
          |> map(fn: (r) => ({r with val: math.round(x: r.val * 1000.0) / 1000.0}))
          |> yield(name: "presence")
        FLUX

      tables = Flux.query query do |row|
        { row["loc"], row["val"].to_f }
      end

      head :no_content if tables.empty?

      locations = tables.first.to_h
      response = response.merge(value: locations.values.sum / locations.size.to_f)
      response = response.merge(locations: locations) if include_locations
    when Window::Aggregate
      logger.warn "aggregate / trend queries not implemented"
      head :not_implemented
    end

    render json: response
  end
end
