require 'spec_helper'

describe "Primary use of the app : " do
  before do
    @user = create :confirmed_user
    visit root_path
    within '.header' do
      click_link 'Login'
    end
    within("#new_user") do
      fill_in 'Email', :with => @user.email
      fill_in 'Password', :with => @user.password
      click_on 'Sign in'
    end
  end

  context "uploading a file", js: true do
    it "should upload an image" do
      pending 'working out the login issue'

      visit uploads_path

      page.should have_css('#uploads-page-file-list .data tr', count: 0)

      within('#upload-page-dropzone') do
        attach_file(:file, 'app/assets/images/file_icon.png', visible: false)
      end

      page.should have_css('#uploads-page-file-list .data tr', count: 1)

    end
  end
end
