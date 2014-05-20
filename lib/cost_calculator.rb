class CostCalculator

  BYTES_IN_GB     = 1073741824
  COST_PER_GB     = 3 # cents
  CHARGE_TO_COST  = 2.00
  STRIPE_PERCENT  = 0.029 # 2.9 percent per transaction
  STRIPE_EXTRA    = 30 # cents per transaction
  MINIMUM_CHARGE  = 50

  attr_writer :bytes
  class_attribute :bytes

  def s3_cost # in cents
    (bytes / (BYTES_IN_GB * 1.00)) * COST_PER_GB
  end

  def charge # in cents
    cost = s3_cost * CHARGE_TO_COST
    cost = ((cost * 1.00) / (100 - (STRIPE_PERCENT * 100.00))) * 100
    (cost + STRIPE_EXTRA).ceil
  end

  def final_charge # in cents
    if charge > MINIMUM_CHARGE
      charge
    else
      MINIMUM_CHARGE
    end
  end
end
