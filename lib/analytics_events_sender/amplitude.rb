module AnalyticsEventsSender
  class Amplitude
    BASE_URL = 'https://api.amplitude.com/httpapi'.freeze

    def ininialize(user, params = {})
      @user = user
      @params = params
    end

    def call
      response = HTTParty.post(BASE_URL, body: event_params, format: :json)

      return false unless response.success?
    end

    private

    def event_params
      {
        api_key: AnalyticsEventsSender.configuration.amplitude.dig(:api_key),
        event: @params
      }
    end
  end
end
