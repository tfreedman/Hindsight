Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/overview' => 'application#overview'
  get '/overview/:year' => 'application#overview'
  get '/date/:yyyy-:mm-:dd', to: 'application#date'
  get '/photos/:id/:format', to: 'application#photos'

  get '/auth/:key' => 'application#auth'

  # Some things require manual recurring imports - you can create a TODO page yourself showing the last
  # time each of those things was last imported. Since this varies per-user, it shouldn't be part of git.
  get '/todo' => 'application#todo'

 root 'application#overview'
end
