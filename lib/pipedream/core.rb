require 'pathname'
require 'yaml'
require 'active_support'
require 'active_support/core_ext/string'

module Pipedream
  module Core
    extend Memoist

    def root
      path = ENV['PIPE_ROOT'] || '.'
      Pathname.new(path)
    end

    def env
      env = ENV['PIPE_ENV'] || 'dev'
      ActiveSupport::StringInquirer.new(env)
    end
    memoize :env

    def env_extra
      env_extra = ENV['PIPE_EXTRA'] if ENV['PIPE_EXTRA'] # highest precedence
      return if env_extra&.empty?
      env_extra
    end
    memoize :env_extra

    def app
      return ENV['PIPE_APP'] if ENV['PIPE_APP']

      if @@config_loaded
        config.app
      else
        call_line = caller.find {|l| l.include?('.PIPE') }
        puts "ERROR: Using PIPE.app or :APP expansion very early in the PIPE boot process".color(:red)
        puts <<~EOL.color(:red)
          The PIPE.app or :APP expansions are not yet available at this point
          You can either:

          1. Use the PIPE_APP env var to set it, which allows it to be used.
          2. Hard code your actual app name.

          Called from:

              #{call_line}

        EOL
        exit 1
      end
    end

    def log_root
      "#{root}/log"
    end

    def configure(&block)
      Config.instance.configure(&block)
    end

    # Checking whether or not the config has been loaded and saving it to @@config_loaded
    # because users can call helper methods in `.CODY/config.rb` files that rely on the config
    # already being loaded. This would produce an infinite loop. The @@config_loaded allows
    # methods to use this info to prevent an infinite loop.
    # Notable methods that use this: CODY.app and CODY.logger
    cattr_accessor :config_loaded
    # In general, use the CODY.config instead of Config.instance.config since it guarantees the load_project_config call
    def config
      Config.instance.load_project_config
      @@config_loaded = true
      Config.instance.config
    end
    memoize :config

    # Allow different logger when running up all or rspec-lono
    cattr_writer :logger
    def logger
      if @@config_loaded
        @@logger = config.logger
      else
        # When .CODY/config.rb is not yet loaded. IE: a helper method like waf
        # gets called in the .CODY/config.rb itself and uses the logger.
        # This avoids an infinite loop. Note: It does create a different Logger
        @@logger ||= Logger.new(ENV['PIPE_LOG_PATH'] || $stderr)
      end
    end
  end
end
