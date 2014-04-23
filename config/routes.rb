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

end
