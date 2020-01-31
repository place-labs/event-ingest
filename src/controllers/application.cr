require "uuid"

abstract class Application < ActionController::Base
  before_action :set_request_id
  before_action :set_date_header
  before_action :authorize!

  def set_request_id
    logger.client_ip = client_ip
    response.headers["X-Request-ID"] = logger.request_id = UUID.random.to_s
  end

  def set_date_header
    response.headers["Date"] = HTTP.format_time(Time.utc)
  end

  def authorize!
    head :forbidden unless request.headers["X-API-Key"]? == API_KEY
  end
end
