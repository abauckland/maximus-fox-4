Rails.application.routes.draw do

  root :to => "projects#index"  

  resources :users, :only => [:index, :show] do
    get :activate, :on => :member
    get :deactivate, :on => :member
  end

  devise_for :users,
    :controllers => { registrations: 'registrations' },
    :path => '',
    :path_names => {:sign_in  => 'login', :sign_out => 'logout' }

  devise_scope :user do
    get '/new_employee' => 'registrations#new_employee'
  end

#  resources :password_resets, :only => [:new, :create, :edit, :update] do
#    get :locked, :on => :member
#    get :deactivated, :on => :member
#  end

  resources :dataexports, :only => [:show] do
    post :download, :on => :member
  end

  resources :companies, :only => [:edit, :update]

  resources :projects

  resources :projectusers

  resources :specifications, :only => [:index, :show] do
    get :empty_project, :on => :member
    get :show_tab_content, :on => :member
  end

  resources :specrevisions, :only => [:index, :show] do
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
    post :add_clauses, :on => :member
    post :delete_clauses, :on => :member
  end

  resources :clauses, :only => [:new, :create] do
    get :new_clone_project_list, :on => :member
    get :new_clone_subsection_list, :on => :member
    get :new_clone_clause_list, :on => :member
  end

  resources :speclines, :only => [:edit, :update] do
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

  resources :alterations do
    get :clause_change_info, :on => :member
    get :line_change_info, :on => :member
    member do
      put :print_setting
    end
  end

  resources :printsettings, :only => [:edit, :update]

  resources :prints, :only => [:show] do
    get :print_project, :on => :member
    get :rint_download, :on => :member
  end


  resources :keynotes, :only => [:show] do
    get :keynote_export, :on => :member
  end

  resources :helps

  resources :termcats, :only => [:index]


  resources :clauseguides do
    get :clone, :on => :member
    get :clone_clause_list, :on => :member
    post :create_clone, :on => :member

    get :assign, :on => :member
    post :assign_guides, :on => :member
  end

  resources :guidenotes do
    get :allocate, :on => :member
  end


  resources :guidepdfs, :only => [:new, :create, :index] do
    get :download, :on => :member
  end


  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :downloadguides
    end
  end 

end