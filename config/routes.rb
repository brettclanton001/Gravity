Gravity::Application.routes.draw do

  # Public Stuff

  root "public#homepage"

  get "/terms"    => "public#terms"
  get "/conditions", to: redirect('/terms')

  get "/privacy"  => "public#privacy"

  get "/support"  => "public#support"
  get "/contact", to: redirect('/support')

  # Devise / User routes

  get "/login",       to: redirect('/users/sign_in')
  get "/sign_in",     to: redirect('/users/sign_in')
  get "/sign_up",     to: redirect('/users/sign_up')
  get "/register",    to: redirect('/users/sign_up')
  delete "/logout",   to: redirect('/users/sign_out')
  delete "/sign_out", to: redirect('/users/sign_out')

  devise_for :users

  get "/account/payment_methods"
  get "/account/payment_history"
  get "/account/settings"
  post "/api/add_user_card" => "account#add_user_card"
  get  "/api/user_payment_methods" => "account#payment_methods"
  get  "/api/user_payment_history" => "account#payment_history"


  # Files
  get "/i/:token" => "uploaded_file#show_file"
  post "uploaded_files" => "uploaded_file#create"

end
