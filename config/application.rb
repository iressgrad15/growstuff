require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Growstuff
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'UTC'
    config.active_record.default_timezone = :local

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    I18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}')]
    I18n.default_locale = :en
    # rails will fallback to config.i18n.default_locale translation
    config.i18n.fallbacks = true
    # rails will fallback to en, no matter what is set as config.i18n.default_locale
    config.i18n.fallbacks = [:en]

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure a default account type
    config.default_account_type = "Free"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Don't try to connect to the database when precompiling assets
    config.assets.initialize_on_precompile = true

    config.generators do |g|
      g.template_engine  :haml
      g.view_specs       false
      g.controller_specs false
      g.helper           false
      g.stylesheets      false
      g.javascripts      false
    end

    config.action_mailer.delivery_method = :sendmail
      config.action_mailer.sendmail_settings = {
        :location       => '/usr/sbin/sendmail',
        :arguments      => '-i -t',
        :openssl_verify_mode  => 'none'
      }

    # Growstuff-specific configuration variables
    config.currency = 'AUD'
    config.bot_email = "noreply@growstuff.org"
    config.user_agent = 'Growstuff'
    config.user_agent_email = "info@growstuff.org"

    Gibbon::API.api_key = ENV['GROWSTUFF_MAILCHIMP_APIKEY'] || 'notarealkey'
      # API key can't be blank or tests fail
    Gibbon::API.timeout = 10
    Gibbon::API.throws_exceptions = false
    config.newsletter_list_id = ENV['GROWSTUFF_MAILCHIMP_NEWSLETTER_ID']

    # This is Growstuff's global Cloudmade key.  If you fork Growstuff for
    # another project/website not run by the folks at http://growstuff.org/,
    # then please change this key. (You can get one of your own at
    # http://account.cloudmade.com/ and it's free/gratis for up to 500k tiles.)
    # We'd much prefer to set this as an environment variable (as we do
    # with most other things) but it turns out those aren't available at
    # asset compile time on Heroku, when we need this to insert into our
    # Javascript. Sigh. And yes, we know about user-env-compile but it
    # didn't work for us.
    config.cloudmade_key = '29a2d9e3cb3d429490a8f338b2388b1d'

  end
end
