module Users
  class SessionsController < Devise::SessionsController
    after_action :store_session_data, only: [:create]
    
    skip_authorization_check if respond_to?(:skip_authorization_check)

    def devise_user
      warden.authenticate(scope: :user)
    end

    def store_session_data
      session["user"] = devise_user
    end
  end
end