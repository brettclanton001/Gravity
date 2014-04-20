require 'spec_helper'

describe "Users" do
  describe "User/Devise registration paths" do

    it "user sign up path" do
      get new_user_registration_path
      response.status.should be(200)
      assert_select "form#new_user" do
        assert_select "input[type=email]"
        assert_select "input[type=password]"
        assert_select "input[type=submit]"
      end
      post_via_redirect "/users", user: {
                             email: "testuser2@example.com",
                             password: "secret123",
                             password_confirmation: "secret123"
                           }
      response.status.should be(200)
      assert_select ".alert", :text => "&times;Welcome! You have signed up successfully."
      assert_select ".header .login-info .current-user-email", :text => "testuser2@example.com"
    end

    it "should allow the user to log out" do
      create_logged_in_user
      delete_via_redirect destroy_user_session_path
      response.status.should be(200)
    end

    it "should allow the user to log in" do
      create_user

      get new_user_session_path
      response.status.should be(200)
      assert_select "form#new_user" do
        assert_select "input[type=email]"
        assert_select "input[type=password]"
        assert_select "input[type=submit]"
      end
      post_via_redirect "/users/sign_in", user: {
                                    email: "testuser@example.com",
                                    password: "secret123"
                                  }
      response.status.should be(200)
      assert_select ".alert", :text => "&times;Signed in successfully."
      assert_select ".header .login-info .current-user-email", :text => "testuser@example.com"
    end

  end
end
