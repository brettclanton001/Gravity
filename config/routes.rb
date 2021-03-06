Gravity::Application.routes.draw do

  # Public Stuff

  root "public#homepage"
  get "/home" => "public#home", as: :homepage

  get "/pricing"    => "public#pricing"

  get "/terms"    => "public#terms"
  get "/conditions", to: redirect('/terms')

  get "/privacy"  => "public#privacy"

  get "/feature_suggestion", to: redirect('http://gravityapp.uservoice.com/forums/258270-general'), as: :feature_suggestion
  get "/support", to: redirect('http://gravityapp.uservoice.com'), as: :support
  get "/contact", to: redirect('http://gravityapp.uservoice.com')

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
  post "/api/add_user_card" => "account#add_user_card"
  get  "/api/user_payment_methods" => "account#payment_methods"
  get  "/api/user_payment_history" => "account#payment_history"


  # Files
  get "/i/:token" => "uploaded_file#show_file"
  post "/uploaded_files" => "uploaded_file#create"


  # Main App Page
  get '/uploads' => "account#uploads", as: :user_root # for devise
  get '/uploads' => "account#uploads", as: :uploads
  get '/all_files' => "account#all_files", as: :all_files

end
