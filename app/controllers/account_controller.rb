class AccountController < ApplicationController
  before_action :authenticate_user!

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
    render json: current_user.stripe_customer.cards.create({card: params[:token]})
  end

end
