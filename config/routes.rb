Pjos::Application.routes.draw do
  resource :dialog do
    collection do
      post :answer
      post :question
      post :reload
    end
  end
  
  root :to => "welcome#index"
end
