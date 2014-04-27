require "stripe"

if Rails.env == 'promotion'
  Stripe.api_key = "UYLCpHFvWkGa0XBeQv07VDtBLwZkXYVR"
  STRIPE_PUBLIC_KEY = 'pk_NGeEB7xYy2V140P5EoQwyTepXxD13'
else
  Stripe.api_key = "b4YfuL6avBxL2RgjuMmLERZ3UFUjR6Lf"
  STRIPE_PUBLIC_KEY = 'pk_tgys8iz6XIxxn8v3gkggQAhzgNvoS'
end

