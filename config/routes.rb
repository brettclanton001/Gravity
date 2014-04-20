Gravity::Application.routes.draw do

  root "public#homepage"
  get "/terms"    => "public#terms"
  get "/privacy"  => "public#privacy"
  get "/support"  => "public#support"

  get "/login",       to: redirect('/users/sign_in')
  get "/sign_in",     to: redirect('/users/sign_in')
  get "/sign_up",     to: redirect('/users/sign_up')
  get "/register",    to: redirect('/users/sign_up')
  delete "/logout",   to: redirect('/users/sign_out')
  delete "/sign_out", to: redirect('/users/sign_out')

  devise_for :users

end
