require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module PFLiveEvents
  class Application < Rails::Application

    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.i18n.enforce_available_locales = false

    config.action_view.field_error_proc = Proc.new { |html_tag, instance| 
      html_tag
    }

    config.middleware.use Rack::Attack

    def load_yaml(file_name)
      config.before_configuration do
        file = File.join(Rails.root, 'config', file_name)
        env_vars = File.exist?(file) ? YAML.load(File.open(file))[Rails.env] : []
        env_vars.each do |key, value|
          ENV[key.to_s] = value
        end if env_vars.present?
      end
    end

    load_yaml('google.yml')
    load_yaml('s3.yml')
    
    # Exception Notification
    config.middleware.use ExceptionNotification::Rack,
      :email => {
        :email_prefix => "[PF-Live-Events Server] ",
        :sender_address => %{"pf-live-event notifier" <gmm.exception.notification@gmail.com>},
        :exception_recipients => %w{gmm.exception.notification@gmail.com, pgregg@playfirst.com}
    }
  end
end
