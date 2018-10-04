require 'httparty'

require 'base64'

require 'analytics_events_sender/dispatcher'
require 'analytics_events_sender/amplitude'
require 'analytics_events_sender/appmetrica'
require 'analytics_events_sender/mixpanel'
require 'analytics_events_sender/version'

module AnalyticsEventsSender
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :amplitude, :mixpanel, :appmetrica, :appsflyer

    # Initialize different platforms parameters
    def initialize
      @amplitude = {}
      @mixpanel = {}
      @appmetrica = {}
      @appsflyer = {}
    end
  end
end
