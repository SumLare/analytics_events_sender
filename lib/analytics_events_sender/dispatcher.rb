module AnalyticsEventsSender
  class Dispatcher
    CANCELATION_EVENT = 'CANCEL'.freeze
    BUY_EVENT = 'INITIAL_BUY'.freeze
    RENEWAL_EVENT = 'RENEWAL'.freeze
    INTERACTIVE_RENEWAL_EVENT = 'INTERACTIVE_RENEWAL'.freeze
    CHANGE_PLAN_EVENT = 'DID_CHANGE_RENEWAL_PREF'.freeze
    DEFAULT_PLATFORMS = %w[amplitude appmetrica appsflyer mixpanel].freeze

    def initialize(params, user, analytics_platforms = DEFAULT_PLATFORMS)
      @user = user
      @analytics_platforms = analytics_platforms
      @cancelation_date = params.dig(:cancellation_date)
      @event_name = params.dig(:notification_type)
      @trial = params.dig(:latest_receipt_info, :is_trial_period)
      @purchase_date = params.dig(:latest_receipt_info, :original_purchase_date).to_datetime
      @product_id = params.dig(:auto_renew_product_id)
      @period = user.receipt['latest_receipt_info'].count
      @new_product_id = params.dig(:latest_receipt_info)
    end

    def call
      @analytics_platforms.each do |platform|
        Kernel.const_get("#{AnalyticsEventsSender}::#{platform.capitalize}").new(@user, event_params, @event_name).call
      end
    end

    private

    def event_params
      case @event_name
      when CANCELATION_EVENT
        { cancelation_date: @cancelation_date, canceledTrial: true, period: @period, subscription_id: @product_id }
      when BUY_EVENT
        { trial: @trial, purhcase_date: @purchase_date, subscription_id: @product_id }
      when RENEWAL_EVENT || INTERACTIVE_RENEWAL_EVENT
        { conversion_from_trial: true, period: @period, subscription_id: @product_id }
      when CHANGE_PLAN_EVENT
        {
          conversion_from_trial: true, old_subscription_id: @product_id,
          new_subscription_id: @new_product_id, period: @period
        }
      end
    end
  end
end
