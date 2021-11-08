# frozen_string_literal: true

Rails.application.routes.draw do
  default_url_options host: ENV['DEFAULT_URL']

  Healthcheck.routes(self)

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  post '/graphql', to: 'graphql#execute'

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post 'api/as/v1/engines/master-podcasts/search', to: 'app_search#search'
  post 'api/as/v1/engines/master-podcasts/query_suggestion', to: 'app_search#query_suggestion'
  post 'api/as/v1/engines/master-podcasts/click', to: 'app_search#click'
  post "twilio_webhook", to: "twilio#webhook"
  get '/trk/:prefix_token/:redirect_url', 
    redirect_url: /(.*)/,
    to: 'trackings#show'
  get '/logo', to: 'global_settings#logo'
  get '/podcast_default_image', to: 'global_settings#podcast_default_image'
  get '/icon', to: 'global_settings#icon'
  get '/master_podcasts/:id/image', to: 'master_podcasts#image', as: "image_master_podcast"
  get '/episodes/:id/image', to: 'episodes#image', as: "image_episode"

  devise_for :users,
  controllers: {
    confirmations: 'auth/confirmations',
    passwords: 'auth/passwords',
    invitations: 'auth/invitations'
  },
  skip: :registrations # skip registration route

  devise_for :podcasts, only: [:confirmations]

  # Just a blank root path
  root to: redirect("/admin")
end
