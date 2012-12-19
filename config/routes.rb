Pjos::Application.routes.draw do
  resources :bones, :only => [ :create, :new ]
  root :to => "welcome#index"
end
