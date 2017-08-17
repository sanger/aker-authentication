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

      rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
        render :text => exception, :status => 500
      end

    end
  end

  def current_user
    if respond_to? :x_auth_user
      auth_user || x_auth_user
    else
      auth_user
    end
  end

  def context
    {current_user: current_user}
  end

  def auth_user
    u = session["user"]
    u = User.new(u) if u.is_a? Hash
    u
  end
end
