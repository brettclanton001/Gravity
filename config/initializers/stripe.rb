require "stripe"

MINIMUM_VALID_CHARGE = 100

Stripe.api_key = ENV['STRIPE_API_KEY']
STRIPE_PUBLIC_KEY = ENV['STRIPE_PUBLIC_KEY']

# Add config to ~/.bashrc or ~/.bash_profile for OSX
# export STRIPE_API_KEY='123'
# export STRIPE_PUBLIC_KEY='abc'
