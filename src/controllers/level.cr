class Level < Application
  base "/level"

  MANLY_LEVEL_1 = "zone-xP3esclNCM"

  MANLY_LOCATIONS = [
    "COhXOOF3Qu-ETdEiL2KaHQ",
    "m7EMKC6cTKih4qqaSEaDqg",
    "n9WNH2eHTK6jSWwPNa8c3w",
    "vykHLJt9RJ-r-uHxQKyu0A",
    "xHJw__yuQWmDqxygrIxEAg",
    "fcYdfhjdQbGdnWFrcrgdDA",
    "zBHQEyx-QDCKfru8ctGawQ",
    "tIAh57GdTEuA-1KCMfd6qg",
    "KElzl4eBTGyzZcfEiwqOlQ",
    "tgnsQ8f3R8y46I0mmWK4jw",
    "QhocYE4JSCGtm0fRQdp12g",
    "GBZLRLmlTxqUXt--at16KQ",
    "bYbr5QBURwiU5MRY1VHTdg",
    "c6N4Y483SRyF8vErXAMHfQ",
    "vooSgb-BQ6WxMcskSDqv2w",
    "Gw2jI4oURq2WFHbTCY8RcQ",
    "2K2PjUgpQV6WAA9L9bOLpA",
    "nKv_dgEzRZ2n9U3tjSzkyw",
    "ThFEZHPrS7yBtNB-7EkffQ",
    "r3YbjVRgQwGZofyOCFESUA",
    "pHp6DUk5SqaYdIGUq2jdJQ"
  ]

  # Tempory endpoint for providing aggregated presence stats.
  get "/:id/presence", :presence do
    if params["id"] == MANLY_LEVEL_1
      if params["include_locations"]?
        locations = random_weights MANLY_LOCATIONS
        render json: {
          event: "presence",
          value: locations.values.sum / locations.size.to_f,
          locations: locations
        }
      else
        render json: {
          event: "presence",
          value: Random.rand,
        }
      end
    else
      head :not_found
    end
  end

  private def random_weights(ids : Array(T)) forall T
    ids.each_with_object({} of T => Float64) do |id, weights|
      weights[id] = Random.rand
    end
  end
end
