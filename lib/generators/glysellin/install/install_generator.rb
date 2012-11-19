require File.expand_path('../utils', __FILE__)

module Glysellin
  class InstallGenerator < Rails::Generators::Base
    include Generators::Utils::InstanceMethods
    # Copied files come from templates folder
    source_root File.expand_path('../templates', __FILE__)

    # Generator desc
    desc "Glysellin install generator"

    def welcome
      do_say "Installing glysellin dependencies and files !"
    end

    def copy_initializer_file
      do_say "Installing default initializer template"
      copy_file "initializer.rb", "config/initializers/glysellin.rb"
    end

    def copy_migrations
      do_say "Installing migrations, don't forget to `rake db:migrate`"
      rake "glysellin_engine:install:migrations"
    end

    def copy_views
      if (ask "Do you want to copy glysellin views to your application views directory ?").presence =~ /^y/i
        rake "glysellin:copy_views"
      end
    end

    def migrate_and_create_default_data
      migrate = ask("Do you want to migrate and install default shop data ? [Y/n]").presence || 'n'
      return unless migrate.match(/^y/i)
      rake "db:migrate"
      rake "glysellin:seed"
    end

    def mount_engine
      mount_path = ask("Where would you like to mount Glysellin shop engine ? [/shop]").presence || '/shop'
      gsub_file "config/routes.rb", /glysellin_at \'\/?.*\'/, ''
      route "glysellin_at '#{mount_path.match(/^\//) ? mount_path : "/#{mount_path}"}'"
    end
  end
end
