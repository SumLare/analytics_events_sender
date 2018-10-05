module AnalyticsEventsSender
  class Dispatcher
    CANCELATION_EVENT = 'CANCEL'.freeze
    BUY_EVENT = 'INITIAL_BUY'.freeze
    RENEWAL_EVENT = 'RENEWAL'.freeze
    INTERACTIVE_RENEWAL_EVENT = 'INTERACTIVE_RENEWAL'.freeze
    CHANGE_PLAN_EVENT = 'DID_CHANGE_RENEWAL_PREF'.freeze
    DEFAULT_PLATFORMS = %w[amplitude appmetrica appsflyer mixpanel].freeze

    def self.call(user, params, analytics_platforms)
      new(user, params, analytics_platforms).call
    end

    def initialize(params, user, analytics_platforms = DEFAULT_PLATFORMS)
      @user = user
      @cancelation_date = params.dig(:cancellation_date)
      @event_name = params[:notification_type]
      @trial = params.dig(:latest_receipt_info, :is_trial_period)
      @purchase_date = params.dig(:latest_receipt_info, :original_purchase_date).to_datetime
      @product_id = params[:auto_renew_product_id]
      @period = user.receipt[:latest_receipt_info].count
    end

    private

    def call
      @analytics_platforms.each do |platform|
        platform.classify.constantize.call(@user, event_params)
      end
    end

    def event_params
      case @event_name
      when CANCELATION_EVENT
        { cancelation_date: @cancelation_date, canceledTrial: true, period: @period, subscription_id: @subscription_id }
      when BUY_EVENT
        { trial: @trial, purhcase_date: @purchase_date, subscription_id: @product_id }
      when RENEWAL_EVENT || INTERACTIVE_RENEWAL_EVENT
        { conversion_from_trial: true, period: @period, subscription_id: @subscription_id }
      when CHANGE_PLAN_EVENT
        {
          conversion_from_trial: true, old_subscription_id: @old_subscription_id,
          new_subscription_id: @new_subscription_id, period: @period
        }
      end
    end
  end
end