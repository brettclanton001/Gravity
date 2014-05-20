namespace :accounting do

  desc "This task finds users that owe enough money to be worth charging them, and charges them."
  task charge_users: :environment do
    Rails.logger.info "Charging Users"
    User.charge_users
  end

end
