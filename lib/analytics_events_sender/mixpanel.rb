module AnalyticsEventsSender
  class Mixpanel
    BASE_URL = 'https://api.mixpanel.com/track/'.freeze
    SUCCESS_CODE = '1'.freeze

    def ininialize(user, params = {})
      @user = user
      @params = params
    end

    def call
      response = HTTParty.post(prepared_url, format: :json)

      success?(response)
    end

    private

    def success?(response)
      response.parsed_response == SUCCESS_CODE
    end

    def prepared_url
      data = Base64.strict_encode64(prepared_json)

      "#{BASE_URL}?data=#{data}"
    end

    def prepared_json
      {
        event: @enent_name,
        properties: {
          token: AnalyticsEventsSender.configuration.mixpanel.dig(:token),
          distinct_id: @user.id
        }.merge(@params)
      }
    end
  end
end
