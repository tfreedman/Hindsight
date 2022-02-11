Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/overview' => 'application#overview'
  get '/overview/:year' => 'application#overview'
  get '/date/:yyyy-:mm-:dd', to: 'application#date'
  get '/photos/:id/:format', to: 'application#photos'

 root 'application#overview'
end
