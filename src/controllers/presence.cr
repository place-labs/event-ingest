class Presence < Application
  base "/"

  get "/location/:id/presence" do
    location = params["id"]
    time = params["at"]?

    now = Time.utc
    time = time.try(&->Time::Format::RFC_3339.parse(String)) || now

    # Queries for the past or now are a direct history lookup
    unless time > now
      signals = ["presence", "people_count"].compact_map do |event|
        History.lookup location, event, time
      end

      head :no_content if signals.empty?

      value = signals.any? &.>(0) ? 1.0 : 0.0
      consensus = signals.count &.==(value)

      render json: {
        value: value,
        confidence: consensus / signals.size.to_f
      }
    end

    # TODO: implement Holt-Winters for forward predictions
    head :not_implemented
  end
end
