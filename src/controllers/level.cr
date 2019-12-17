class Level < Application
  base "/level"

  LOCATIONS = {
    # Manly
    "zone-xP3esclNCM" => [
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
    ],

    # The Broo'
    "zone-y3qRLrZGVs" => [
      "table-10.0P1", "table-10.0P2", "table-10.030",
      "table-10.029", "table-10.028", "table-10.034",
      "table-10.035", "table-10.036", "table-10.042",
      "table-10.041", "table-10.040", "table-10.046",
      "table-10.047", "table-10.048", "table-10.039",
      "table-10.038", "table-10.037", "table-10.043",
      "table-10.044", "table-10.045", "table-10.027",
      "table-10.026", "table-10.025", "table-10.031",
      "table-10.032", "table-10.033", "table-10.024",
      "table-10.023", "table-10.022", "table-10.016",
      "table-10.017", "table-10.018", "table-10.012",
      "table-10.011", "table-10.010", "table-10.004",
      "table-10.005", "table-10.006", "table-10.009",
      "table-10.008", "table-10.007", "table-10.001",
      "table-10.002", "table-10.003", "table-10.021",
      "table-10.020", "table-10.019", "table-10.013",
      "table-10.014", "table-10.015", "table-10.01D",
      "table-10.054", "table-10.060", "table-10.059",
      "table-10.053", "table-10.052", "table-10.058",
      "table-10.066", "table-10.072", "table-10.071",
      "table-10.065", "table-10.064", "table-10.070",
      "table-10.069", "table-10.063", "table-10.062",
      "table-10.068", "table-10.067", "table-10.061",
      "table-10.057", "table-10.051", "table-10.050",
      "table-10.056", "table-10.055", "table-10.049",
      "table-10.073", "table-10.079", "table-10.080",
      "table-10.074", "table-10.075", "table-10.081",
      "table-10.076", "table-10.082", "table-10.083",
      "table-10.077", "table-10.078", "table-10.084",
      "table-10.090", "table-10.096", "table-10.095",
      "table-10.089", "table-10.088", "table-10.094",
      "table-10.087", "table-10.093", "table-10.092",
      "table-10.086", "table-10.085", "table-10.091",
      "table-10.097", "table-10.103", "table-10.104",
      "table-10.098", "table-10.099", "table-10.105",
      "table-10.109", "table-10.115", "table-10.116",
      "table-10.110", "table-10.111", "table-10.117",
      "table-10.102", "table-10.108", "table-10.107",
      "table-10.101", "table-10.100", "table-10.106",
      "table-10.112", "table-10.118", "table-10.119",
      "table-10.113", "table-10.114", "table-10.120",
      "table-10.0D2", "table-10.126", "table-10.132",
      "table-10.131", "table-10.125", "table-10.124",
      "table-10.130", "table-10.138", "table-10.144",
      "table-10.143", "table-10.137", "table-10.136",
      "table-10.142", "table-10.141", "table-10.135",
      "table-10.134", "table-10.140", "table-10.139",
      "table-10.133", "table-10.123", "table-10.129",
      "table-10.128", "table-10.122", "table-10.121",
      "table-10.127", "table-10.147", "table-10.150",
      "table-10.149", "table-10.146", "table-10.145",
      "table-10.148", "table-10.151", "table-10.154",
      "table-10.155", "table-10.152", "table-10.153",
      "table-10.156", "table-10.B16", "table-10.169",
      "table-10.175", "table-10.176", "table-10.170",
      "table-10.171", "table-10.177", "table-10.157",
      "table-10.163", "table-10.164", "table-10.158",
      "table-10.159", "table-10.165", "table-10.178",
      "table-10.172", "table-10.173", "table-10.179",
      "table-10.180", "table-10.174", "table-10.166",
      "table-10.160", "table-10.161", "table-10.167",
      "table-10.168", "table-10.162", "table-10.KT1",
      "table-10.0B5", "table-10.12", "table-10.0B6",
      "table-10.0B7", "table-10.B11", "table-10.0B9",
      "table-10.B10", "table-10.0B8", "table-10.0F8",
      "table-10.0F9", "table-10.F27", "table-10.F28",
      "table-10.F10", "table-10.F17", "table-10.F25",
      "table-10.F12", "table-10.F11", "table-10.F16",
      "table-10.F15", "table-10.F23", "table-10.F22",
      "table-10.F14", "table-10.F13", "table-10.0F2",
      "table-10.0F3", "table-10.0F4", "table-10.0F7",
      "table-10.0F6", "table-10.F4A", "table-10.0F1",
      "table-10.F18", "table-10.F21", "table-10.F20",
      "table-10.F19", "table-10.F25", "table-10.F24",
      "table-10.F29", "table-10.F30", "table-10.F32",
      "table-10.F33", "table-10.0F5", "table-10.F31",
      "table-10.0B2", "table-10.0B4", "table-10.KT2",
      "table-10.0N2", "table-10.0N1", "table-10.0B1",
      "table-1"
    ]
  }

  # Tempory endpoint for providing aggregated presence stats.
  get "/:id/presence", :presence do
    level = params["id"]
    locations = LOCATIONS[level]?

    head :not_found unless locations

    if params["include_locations"]?
      weights = random_weights locations
      render json: {
        event: "presence",
        value: weights.values.sum / weights.size.to_f,
        locations: weights
      }
    else
      render json: {
        event: "presence",
        value: Random.rand,
      }
    end
  end

  private def random_weights(ids : Array(T)) forall T
    ids.each_with_object({} of T => Float64) do |id, weights|
      weights[id] = Random.rand
    end
  end
end
