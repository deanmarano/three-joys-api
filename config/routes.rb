Rails.application.routes.draw do
  namespace :v1 do
    resource :session, except: [:new, :edit]
  end
end
