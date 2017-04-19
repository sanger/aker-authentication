class User < ApplicationRecord
  devise :ldap_authenticatable, :rememberable, :trackable

  attr_accessor :groups

  def groups
    @groups ||= fetch_groups
  end

  def to_jwt_data
    {"groups" => groups}.merge(attributes)
  end

  def self.from_jwt_data(hash)
    #debugger
    return nil if hash.nil?
    obj = User.new(hash.reject{|k,v| k=='groups'})
    obj.groups = hash['groups']
    #debugger
    obj
  end

  def fetch_groups
    # Doing this for now as not actually wanting to look up information from LDAP so stubbing
    return ['pirates', 'world'] if Rails.configuration.fake_ldap
    name = self.email
    DeviseLdapAuthenticatable::Logger.send("Getting groups for #{name}")
    connection = Devise::LDAP::Adapter.ldap_connect(name)
    filter = Net::LDAP::Filter.eq("member", connection.dn)
    connection.ldap.search(:filter => filter, :base => Rails.application.config.ldap["group_base"]).collect(&:cn).flatten
  end
end
