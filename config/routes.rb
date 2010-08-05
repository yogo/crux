# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: routes.rb
# 
#
ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  map.namespace :yogo do |yogo|
    yogo.resources :projects,
                   :member => {  :upload => :post, :kefed_editor => :get,
                                :kefed_library => :get, :add_kefed_diagram => :get },
                  :collection => { :loadexample => :post, :search => :get} do |project|
    
      project.resources :collections
      
      project.resources :items
                      
      project.resources :users, :controller => 'yogo/users', 
                                :only => [:index, :new, :create], 
                                :collection => { :update_user_roles => :post }
    end
  end

  map.dashboard "/dashboard", :controller => 'yogo/projects', :action => 'index'

  # map.connect "/mockup/:action", :controller => 'mockup'
  
  # Wizard stuff
  # map.start_wizard  "/project_wizard/name", 
  #                   :controller => 'project_wizard', :action => 'name'
  # map.create_wizard_project "/project_wizard/", 
  #                           :controller => 'project_wizard', :action => 'create'
  # map.csv_question  "/project_wizard/csv_question/:id", 
  #                   :controller => 'project_wizard', :action => 'csv_question'
  # map.import_csv  "/project_wizard/import_csv/:id", 
  #                 :controller => 'project_wizard', :action => 'import_csv'
  # map.upload_csv_wizard "/project_wizard/upload_csv/:id", 
  #                       :controller => 'project_wizard', :action => 'upload_csv'

  
  map.resources :settings
  map.resource :password, :only => [ :show, :update, :edit ]
  map.resources :users
  map.resources :roles
  
  # Login & Logout stuff
  map.resource :user_session, :only => [ :show, :new, :create, :destory ]
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "yogo/projects"
end
