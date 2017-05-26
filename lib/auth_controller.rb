module AkerAuthenticationGem::AuthController
  def self.included(base)
    base.instance_eval do |klass|

      before_action do |controller|
        request.parameters["user"]["email"] += '@sanger.ac.uk' unless request.parameters["user"].nil? || request.parameters["user"]["email"].include?('@')
        authenticate_user! unless self.class.skip_authenticate_user?(self.action_name.to_sym)
      end

      def self.skip_authenticate_user?(action)
        if @options_authenticate_user.nil? ||
            @options_authenticate_user[:only].nil? ||
            @options_authenticate_user[:only].include?(action)
          return @skip_authenticate_user
        end
        return false
      end


      def self.skip_authenticate_user(options=nil)
        @skip_authenticate_user = true
        @options_authenticate_user = options
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