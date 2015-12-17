Rails.application.routes.draw do
  resources :tasks, except: [:new, :edit] do
  	post 'shutdown', on: :member
  end
end
