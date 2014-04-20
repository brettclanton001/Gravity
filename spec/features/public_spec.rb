require 'spec_helper'

describe "Public Paths" do

  describe "Homepage" do
    before do
      visit '/'
    end

    it "Should have a logo text" do
      page.should have_text('Gravity')
    end

    it "Should have a slogan" do
      page.should have_text('you still own it')
      page.should have_text('and it\'s awesome')
    end

    it "Should have a place to drop your files" do
      page.should have_text('drop files here')
    end

    it "Should have a prompt to learn more and scroll down" do
      page.should have_text('learn more')
    end

  end

  describe "Privacy" do
    before do
      visit '/privacy'
    end

    it "Should have a header" do
      page.should have_text('Privacy Policy')
    end

  end

  describe "Terms" do
    before do
      visit '/terms'
    end

    it "Should have a header" do
      page.should have_text('Terms and Conditions')
    end

  end

  describe "Support" do
    before do
      visit '/support'
    end

    it "Should have a header" do
      page.should have_text('Contacting Support')
    end

  end

end
