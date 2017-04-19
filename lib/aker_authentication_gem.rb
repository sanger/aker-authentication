require "aker_authentication_gem/version"

#autoload :User, 'models/user'


#module Users
#  autoload :SessionsController, 'controllers/users/sessions_controller'
#end


require "devise"
require "net-ldap"
require "devise_ldap_authenticatable"
require "request_store"
require "jwt"

module AkerAuthenticationGem
  autoload :AuthController, 'auth_controller'
  class Engine < ::Rails::Engine
    isolate_namespace AkerAuthenticationGem
  end
end
