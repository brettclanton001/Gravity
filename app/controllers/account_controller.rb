class AccountController < ApplicationController
  before_action :authenticate_user!

  def payment_methods
  end

  def payment_history
  end

  def settings
  end

  def add_user_card
    card = current_user.stripe_customer.cards.create({card: params[:token]})
    render json: { number: card[:last4], expire: "#{card[:exp_month]}/#{card[:exp_year]}" }
  end
end
