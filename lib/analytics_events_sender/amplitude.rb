module AnalyticsEventsSender
  class Amplitude
    BASE_URL = 'https://api.amplitude.com/httpapi'.freeze

    def initialize(user, params = {}, event_name)
      @user = user
      @params = params
      @event_name = event_name
    end

    def call
      response = HTTParty.post(BASE_URL, query: prepared_params)

      return false unless response.success?
    end

    private

    def prepared_params
      {
        api_key: AnalyticsEventsSender.configuration.amplitude.dig(:api_key),
        event: {
          event_properties: @params,
          user_id: @user.id,
          event_type: @event_name
        }.to_json
      }
    end
  end
end
