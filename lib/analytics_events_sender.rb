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
