class History < Application
  base "/"

  # Provides the state of a tracked param at a previous point in time.
  get "/location/:id/state/:event" do
    location = params["id"]
    event = params["event"]
    time = params["at"]?

    now = Time.utc
    if time
      time = Time::Format::RFC_3339.parse(time)
      head :bad_request if time > now
    else
      time = now
    end

    # OPTIMIZE: lookup level first and use this to filter before pivot
    query = <<-FLUX
      from(bucket: "place")
        |> range(start: #{(time - 3.days).to_rfc3339}, stop: #{time.to_rfc3339})
        |> filter(fn: (r) => r._measurement == "#{event}")
        |> pivot(rowKey: ["_time", "lvl", "src"], columnKey: ["_field"], valueColumn: "_value")
        |> filter(fn: (r) => r.loc == "#{location}")
        |> rename(columns: {"val": "_value"})
        |> last()
      FLUX

    response = Flux.query query do |row|
      row["_value"].to_f
    end

    head :no_content if response.empty?

    render json: {
      value: response.first.first
    }
  end
end
