module AkerAuthenticationGem::AuthController
  def self.included(base)
    base.instance_eval do |klass|

      before_action do
        request.parameters["user"]["email"] += '@sanger.ac.uk' unless request.parameters["user"].nil? || request.parameters["user"]["email"].include?('@')
        authenticate_user!
      end


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

      rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
          render :text => exception, :status => 500
      end      
    end
  end
end