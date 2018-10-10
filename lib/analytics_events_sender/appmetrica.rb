module AnalyticsEventsSender
  class Appmetrica
    BASE_URL = 'https://api.appmetrica.yandex.com/logs/v1/import/events'.freeze

    def initialize(user, params = {}, event_name)
      @user = user
      @params = params
      @event_name = event_name
    end

    def call
      response = HTTParty.post(complete_url + '&' + prepared_params)

      return false unless response.success?
    end

    private

    def complete_url
      key = AnalyticsEventsSender.configuration.appmetrica.dig(:api_key)

      "#{BASE_URL}?post_api_key=#{key}"
    end

    def prepared_params
      {
        application_id: AnalyticsEventsSender.configuration.appmetrica.dig(:app_id),
        profile_id: @user.id, event_name: @event_name,
        event_timestamp: Time.now.to_i, event_json: @params.to_json
      }.map { |key, value| "#{key}=#{value}" }.join('&')
    end
  end
end
