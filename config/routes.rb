Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'chain#index'
  post '/handle_submit', to: 'chain#handle_submit'
end
