class PublicController < ApplicationController
  def homepage
    unless current_user
      @is_homepage = true
    else
      redirect_to uploads_path
    end
  end

  def home
    @is_homepage = true
    render :homepage
  end

  def terms
  end

  def privacy
  end

  def support
  end
end
