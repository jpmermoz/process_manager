Rails.application.routes.draw do
	root to: "pages#index"
	
  resources :tasks, except: [:new, :edit] do
  	post 'shutdown', on: :member
  end
end
