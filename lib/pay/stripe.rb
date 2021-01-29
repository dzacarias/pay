require "pay/env"
require "pay/stripe/billable"
require "pay/stripe/charge"
require "pay/stripe/subscription"
require "pay/stripe/webhooks"

module Pay
  module Stripe
    include Env

    extend self

    def setup
      ::Stripe.api_key = private_key
      ::Stripe.api_version = "2020-08-27"
      ::StripeEvent.signing_secret = signing_secret
      ::Stripe.set_app_info(
        "PayRails",
        partner_id: "pp_partner_XXXX", # Used by Stripe to identify your plugin
        version: Pay::VERSION,
        url: "https://github.com/pay-rails/pay"
      )

      Pay.charge_model.include Pay::Stripe::Charge
      Pay.subscription_model.include Pay::Stripe::Subscription
    end

    def public_key
      find_value_by_name(:stripe, :public_key)
    end

    def private_key
      find_value_by_name(:stripe, :private_key)
    end

    def signing_secret
      find_value_by_name(:stripe, :signing_secret)
    end
  end
end
