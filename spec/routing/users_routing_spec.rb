require "spec_helper"

describe "routing" do

  it "routes to login" do
    get("/users/sign_in").should route_to("devise/sessions#new")
  end

  it "routes to logout" do
    delete("/users/sign_out").should route_to("devise/sessions#destroy")
  end

  it "routes to sign up" do
    get("/users/sign_up").should route_to("devise/registrations#new")
  end

end
