require 'yaml'
require './lib/utility/transform_keys_to_sym'

module App
  module Config
    class << self
      APPLICATION_CONFIG_FILENAME = 'config/application.yml'.freeze

      def config
        @config unless @config.nil?

        application_config = YAML.load_file(application_config_filename) || {}
        environment_config = YAML.load_file(environment_config_filename) || {}

        @config = Utility.transform_keys_to_sym(application_config.merge(environment_config))
      end

      private

      def application_config_filename
        APPLICATION_CONFIG_FILENAME
      end

      def environment_config_filename
        "config/environments/#{ENV['APP_ENV']}.yml"
      end
    end

    def config
      App::Config.config
    end
  end
end
