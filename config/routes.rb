Rails.application.routes.draw do
  root 'welcome#index'
  get '/api/words/:name' => 'words#query'
end
