class AkerAuthController < ApplicationController
  # Checks authorization has been performed for every action
  # Throws an error if not
  # See https://github.com/ryanb/cancan/wiki/Ensure-Authorization
  
  #TODO: 
  check_authorization

  before_action :apply_credentials

  #rescue_from CanCan::AccessDenied do |exception|
  #  respond_to do |format|
  #    format.api_json { head :forbidden, content_type: 'application/vnd.api+json' }
  #    format.json { head :forbidden, content_type: 'text/html' }
  #    format.html { redirect_to root_path, alert: exception.message }
  #    format.js   { head :forbidden, content_type: 'text/html' }
  #  end
  #end

  private

  def context
    {current_user: current_user}
  end

  def current_user
    u = session["user"]
    if u.is_a? Hash
      u = User.new(u)
    end
    u
  end

  include JWTCredentials

  # def check_credentials
  #   if request.headers.to_h['HTTP_X_AUTHORISATION']
  #     begin
  #       secret_key = Rails.configuration.jwt_secret_key
  #       token = request.headers.to_h['HTTP_X_AUTHORISATION']
  #       payload, header = JWT.decode token, secret_key, true, { algorithm: 'HS256'}
  #       ud = payload["data"]
  #       session["user"] = {
  #         "user" => ud["user"], #User.find_or_create_by(email: ud["user"]["email"]),
  #         "groups" => ["world"]#ud["groups"].join(',') #ud["groups"].map { |name| Group.find_or_create_by(name: name) },
  #       }

  #     rescue JWT::VerificationError => e
  #       render body: nil, status: :unauthorized
  #     rescue JWT::ExpiredSignature => e
  #       render body: nil, status: :unauthorized
  #     end
  #   else
  #     session["user"] = {
  #       "user" => {email: "guest"},
  #       "groups" => ["world"]
  #     }
  #   end
  # end  

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
      render :text => exception, :status => 500
  end
end