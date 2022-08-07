Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'welcome#index'
  get '/api/words/:name' => 'words#query'
end
