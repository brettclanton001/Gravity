class AccountController < ApplicationController
  before_action :authenticate_user!

  def payment_methods
  end

  def payment_history
  end

  def settings
  end
end
