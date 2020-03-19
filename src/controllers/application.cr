require "uuid"

module PlaceOS::Analytics
  private abstract class Application < ActionController::Base
    before_action :set_request_id
    before_action :set_date_header
    before_action :log_client_ip
    before_action :authorize!

    def set_request_id
      request_id = request.headers["X-Request-ID"]? || UUID.random.to_s
      response.headers["X-Request-ID"] = request_id
      logger.request_id = request_id
    end

    def set_date_header
      response.headers["Date"] = HTTP.format_time(Time.utc)
    end

    def log_client_ip
      logger.client_ip = client_ip
    end

    def authorize!
      head :forbidden unless request.headers["X-API-Key"]? == App::API_KEY
    end
  end
end
