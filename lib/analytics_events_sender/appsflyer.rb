module AnalyticsEventsSender
  class Appsflyer
    BASE_URL = 'https://api2.appsflyer.com/inappevent'.freeze

    def initialize(user, params = {})
      @user = user
      @params = params
      @event_name = params.dig(:notification_type)
    end

    def call
      return false unless @user.appsflyer_id

      api_key = AnalyticsEventsSender.configuration.appsflyer.dig(:api_key)
      response = HTTParty.post(BASE_URL, body: event_params, headers: { authentication: api_key })

      return false unless response.success?
    end

    private

    def complete_url
      app_id = AnalyticsEventsSender.configuration.appsflyer.dig(:app_id)
      "#{base_ur}/#{app_id}"
    end

    def prepated_params
      customer_params = {
        appsflyer_id: @user.appsflyer_id, customer_user_id: @user.id, af_events_api: true
      }
      customer_params.merge(event_params).to_json
    end

    def event_params
      {
        event_name: @event_name,
        event_value: @params.transform_values(&:to_s)}.to_s,
        event_time: @event_time
      }.transform_keys { |key| key.to_s.split('_').map(&:capitalize).join }
        .transform_values(&:to_s)
    end
  end
end
