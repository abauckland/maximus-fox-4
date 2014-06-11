Rails.application.routes.draw do

  resources :performkeys

  resources :performkeys

  resources :printsettings

  resources :companies

  resources :abouts

  resources :featurecontents

  resources :features

  resources :priceplans
  
  resources :helps
  
  resources :exports do
    get :keynote_export, :on => :member
  end 
 
  resources :prints do
    get :print_project, :on => :member
  end

  root :to => "homes#index"  

  get "home" => "homes#index", :as => "home"

  get "sign_up" => "companies#new", :as => "sign_up"
  get "faqs" => "faqs#index", :as => "faqs"
  get "terms" => "termcats#index", :as => "terms"
  get "about_us" => "abouts#index", :as => "about_us"
  get "pricing" => "priceplans#index", :as => "pricing"
  
  get "log_out" => "sessions#destroy", :as => "log_out"
  
  resources :helps

  resources :faqs

  resources :terms

  resources :sessions do
    collection do
      post :create_session
    end    
  end

  resources :users do
 #   get :new_users, :on => :member
 #   get :edit_user_details, :on => :member
    get :update_status, :on => :member
    get :unlock, :on => :member
#    get :unlocked, :on => :member
 #   member do
 #     put :update_status
 #     put :update_user_details
 #   end
  end

  resources :password_resets do
    get :locked, :on => :member
    get :deactivated, :on => :member
  end

  resources :projects

  resources :projectusers
  
  resources :specifications do
    get :empty_project, :on => :member  
    get :show_tab_content, :on => :member  
  end
  
  resources :specrevisions do
    get :show_prelim_tab_content, :on => :member
    get :show_rev_tab_content, :on => :member
  end

  resources :specsubsections do
    get :manage, :on => :member
    post :add, :on => :member
    post :delete, :on => :member
  end

  resources :specclauses do
    get :manage, :on => :member
    get :add_clauses, :on => :member
    post :delete_clauses, :on => :member
  end
  
  resources :clauses do
    post :clause_ref_select, :on => :member
    get :subclause_select, :on => :member
    get :new_clone_project_list, :on => :member
    get :new_clone_subsection_list, :on => :member
    get :new_clone_clause_list, :on => :member    
  end

  resources :speclines do
    delete :delete_clause, :on => :member
    get :new_specline, :on => :member
    delete :delete_specline, :on => :member
    get :guidance, :on => :member
    get :xref_data, :on => :member
             
    member do
    put :move_specline
    put :update_specline_3
    put :update_specline_4
    put :update_specline_5
    put :update_specline_6
    put :update_product_key
    put :update_product_value       
    end    
  end

  resources :reinstates do
    get :reinstate, :on => :member
    get :reinstate_clause, :on => :member
  end

  resources :changes do
    get :clause_change_info, :on => :member
    get :line_change_info, :on => :member
    member do
      put :print_setting
    end
  end



      
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
