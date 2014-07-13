class AccountController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def uploads
    @is_upload_page = true
    if !current_user.active_payments && current_user.discount_percent < 100
      redirect_to account_payment_methods_path, alert: 'You must have an active payment method on file to use this application.'
    end
    @files = current_user.uploaded_files.order('created_at DESC').first(20)
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

  def all_files
    @files = current_user.uploaded_files.order('created_at DESC').paginate(:page => params[:page], :per_page => 100)
  end

  def add_user_card
    new_card = current_user.stripe_customer.cards.create({card: params[:token]})
    current_user.update_attribute(:active_payments, true) unless current_user.active_payments
    render json: new_card
  end
end
