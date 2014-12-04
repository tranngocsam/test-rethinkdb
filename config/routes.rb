Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      namespace :tr do
        resources :requests do
          collection do
            post :top_ups_and_redeems
          end
        end
      end
      
      namespace :report do
        resources :requests do
          collection do
            post :report
          end
        end
      end
    end 
  end 

  match '*all', :to => "pages#options", :via => [:options]
end
