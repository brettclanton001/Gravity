class AccountController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def uploads
    redirect_to account_payment_methods_path, alert: 'You must have an active payment method on file to use this application.' unless current_user.active_payments
  end

  def payment_methods
    respond_to do |format|
      format.html
      format.json { render json: current_user.payment_methods}
    end
  end

  def payment_history
    respond_to do |format|
      format.html
      format.json { render json: current_user.payment_history}
    end
  end

  def settings
  end

  def add_user_card
    new_card = current_user.stripe_customer.cards.create({card: params[:token]})
    current_user.update_attribute(:active_payments, true) unless current_user.active_payments
    render json: new_card
  end
end
