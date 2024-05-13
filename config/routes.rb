Rails.application.routes.draw do
  get 'forecasts/index'
  post 'forecasts' => "forecasts#fetch"
  get 'forecast/:zipcode' => "forecasts#show"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "forecasts#index"
end
