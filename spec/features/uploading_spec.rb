require 'spec_helper'

describe "Primary use of the app : " do
  def file_hash
    token = SecureRandom.urlsafe_base64(4)
    "{created_at: \"#{Time.now.as_json}\", id: 1, thumbnail: \"/assets/file_icon.png\", token: \"#{token}\", url: \"http://localhost:3000/i/#{token}\"}"
  end

  before do
    @user = create :confirmed_user
    visit sign_in_path
    fill_in 'Email', :with => @user.email
    fill_in 'Password', :with => @user.password
    click_on 'Sign in'
  end

  context "uploading a file", js: true do
    it "should respond to the expected result of uploaded files" do

      visit uploads_path

      page.should have_css('#uploads-page-file-list .data tr', count: 0)
      find(:css, '.view-all-files a', visible: false).visible?.should be_false
      find(:css, '.first-time-instructions').visible?.should be_true

      page.execute_script "window.dz_new_file(#{file_hash})"
      page.should have_css('#uploads-page-file-list .data tr', count: 1)

      find(:css, '.view-all-files a').visible?.should be_true
      find(:css, '.first-time-instructions', visible: false).visible?.should be_false

      page.execute_script "window.dz_new_file(#{file_hash})"
      page.should have_css('#uploads-page-file-list .data tr', count: 2)

    end
  end
end
