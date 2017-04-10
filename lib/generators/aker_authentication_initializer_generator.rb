class AkerAuthenticationInitializerGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)


  def self.next_migration_number(dir)
    Time.now.strftime("%Y%m%d%H%M%S")
  end

  def create_users_migration
    migration_template 'migration_template.rb', 'db/migrate/aker_create_users.rb'
  end
end