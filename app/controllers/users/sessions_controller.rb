module Users
  class SessionsController < Devise::SessionsController
    after_action :store_session_data, only: [:create]
    
    skip_authorization_check if respond_to?(:skip_authorization_check)

  protected

    def store_session_data
      session["user"] = current_user
    end

  end
end