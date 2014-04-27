require 'spec_helper'

describe AccountController do

  describe "GET 'payment_methods'" do
    it "returns http success" do
      get '/account/payment_methods'
      response.should_not be_success
    end
  end

  describe "GET 'payment_history'" do
    it "returns http success" do
      get '/account/payment_history'
      response.should_not be_success
    end
  end

  describe "GET 'settings'" do
    it "returns http success" do
      get '/account/settings'
      response.should_not be_success
    end
  end

end
