require 'spec_helper'

describe "Public Paths" do

  describe "Homepage" do

  end

  describe "Privacy" do

  end

  describe "Terms" do

    it "should support contact route" do
      get_via_redirect '/conditions'
      response.status.should be 200
    end

  end

  describe "Support" do

    it "should support contact route" do
      get_via_redirect '/contact'
      response.status.should be 200
    end

  end

end
