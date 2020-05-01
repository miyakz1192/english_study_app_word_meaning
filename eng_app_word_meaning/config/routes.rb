Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # JP resource is here "https://railsguides.jp/routing.html"
  resources :word, only: [:index]
  get 'words/index'
  get 'words/:sentence_no', to: 'words#get'
  post 'words/:sentence_no', to: 'words#register'
end
