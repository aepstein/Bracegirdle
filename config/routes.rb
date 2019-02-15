Rails.application.routes.draw do
  get 'dashboard/index'

  # Cemeteries
  resources :cemeteries
  get 'cemeteries/:id/trustees', to: 'cemeteries#show', defaults: { tab: :trustees }, as: :cemetery_trustees
  post 'cemeteries/:id/trustees/new' => 'cemeteries#create_new_trustee', as: :create_new_trustee
  get 'cemeteries/:id/trustees/new' => 'cemeteries#new_trustee', as: :new_trustee
  get 'cemeteries/:id/trustees/:trustee/edit' => 'cemeteries#edit_trustee', as: :edit_trustee
  patch 'cemeteries/:id/trustees/:trustee/edit' => 'cemeteries#update_trustee'
  get 'cemeteries/county/:county' => 'cemeteries#list_by_county'
  get 'cemeteries/region/:region' => 'cemeteries#list_by_region'
  get 'cemeteries/:id/rules', to: 'rules#show_approved', as: :cemetery_rules

  # Complaints
  get 'complaints/unassigned', to: 'complaints#unassigned', as: :unassigned_complaints
  get 'complaints/pending-closure', to: 'complaints#pending_closure', as: :complaints_pending_closure
  get 'complaints/all', to: 'complaints#all', as: :all_complaints
  resources :complaints do
    resources :notes, module: :complaints
  end
  get 'complaints/:id/investigation-details', to: 'complaints#show', defaults: { tab: :investigation }, as: :complaint_investigation
  patch 'complaints/:id/update-investigation', to: 'complaints#update_investigation', as: :complaint_update_investigation

  # Errors
  get '/403', to: 'errors#forbidden'
  get '/500', to: 'errors#internal_server_error'

  # Notices
  resources :notices do
    resources :notes, module: :notices
  end
  get 'notices/:id/download', to: 'notices#download', as: :download_notice
  patch 'notices/:id/update-parameters', to: 'notices#update_status', as: :notice_update_status

  # Rules
  get 'rules/region/:region', to: 'rules#index', as: :regional_rules
  get 'rules/upload-old-rules', to: 'rules#upload_old_rules', as: :upload_old_rules
  post 'rules/upload-old-rules', to: 'rules#create_old_rules', as: :create_old_rules
  resources :rules do
    resources :notes, module: :rules
  end
  get 'rules/:id/download-approval', to: 'rules#download_approval', as: :download_rules_approval
  patch 'rules/:id/upload-revision', to: 'rules#upload_revision', as: :rules_upload_revision
  patch 'rules/:id/review', to: 'rules#review', as: :rules_review

  # Users
  resources :sessions, only: [:new, :create, :destroy]
  get 'login' => 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  # Vandalism
  get 'vandalism/abandonment', to: 'vandalism#index_abandonment', as: :vandalism_abandonment
  get 'vandalism/hazardous', to: 'vandalism#index_hazardous', as: :vandalism_hazardous
  get 'vandalism/vandalism', to: 'vandalism#index_vandalism', as: :vandalism_vandalism
  resources :vandalism

  root 'dashboard#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
