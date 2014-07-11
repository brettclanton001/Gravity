class CostCalculator

  BYTES_IN_GB     = 1073741824
  COST_PER_GB     = 3 # cents
  CHARGE_TO_COST  = 2.00 # to account for non S3 overhead/costs
  STRIPE_PERCENT  = 0.029 # 2.9 percent per transaction
  STRIPE_EXTRA    = 30 # cents per transaction
  MAXIMUM_CHARGE  = 500 # $5.00
  MINIMUM_CHARGE  = 50 # $0.50

  attr_writer :bytes
  class_attribute :bytes

  def s3_cost # in cents - how much did this usage cost us in Amazon S3
    (bytes / (BYTES_IN_GB * 1.00)) * COST_PER_GB
  end

  def charge # in cents - how much we could/should charge the user with given usage
    cost = s3_cost * CHARGE_TO_COST
    cost = ((cost * 1.00) / (100 - (STRIPE_PERCENT * 100.00))) * 100
    (cost + STRIPE_EXTRA).ceil
  end

  def final_charge # in cents - what we actually charge
    if charge > MAXIMUM_CHARGE
      MAXIMUM_CHARGE # enforce maximum charge
    elsif charge > MINIMUM_CHARGE
      charge
    else
      MINIMUM_CHARGE # enforce minimum charge
    end
  end
end
