Rails.application.routes.draw do
  get "/help", to: "static_pages#help"
  get "/about",to: "static_pages#about"
  get "/home", to: "static_pages#home"

root "static_pages#home"
end
