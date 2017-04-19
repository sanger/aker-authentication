module AkerAuthenticationGem::AuthController
  def self.included(base)
    base.instance_eval do |klass|

      before_action do
        request.parameters["user"]["email"] += '@sanger.ac.uk' unless request.parameters["user"].nil? || request.parameters["user"]["email"].include?('@')
        authenticate_user! unless self.class.skip_authenticate_user?
      end

      def self.skip_authenticate_user?
        (self.class_variable_defined? "@@skip_authenticate_user") && @@skip_authenticate_user
      end

      def self.skip_authenticate_user
        @@skip_authenticate_user = true
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