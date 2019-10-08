require 'pathname'
require 'yaml'
require 'active_support/core_ext/string'

module Pipedream
  module Core
    extend Memoist

    def root
      path = ENV['PIPE_ROOT'] || '.'
      Pathname.new(path)
    end

    def env
      # 2-way binding
      pipe_env = env_from_profile || 'development'
      pipe_env = ENV['PIPE_ENV'] if ENV['PIPE_ENV'] # highest precedence
      ActiveSupport::StringInquirer.new(pipe_env)
    end
    memoize :env

    def env_extra
      env_extra = ENV['PIPE_ENV_EXTRA'] if ENV['PIPE_ENV_EXTRA'] # highest precedence
      return if env_extra&.empty?
      env_extra
    end
    memoize :env_extra

    # Overrides AWS_PROFILE based on the Pipedream.env if set in configs/settings.yml
    # 2-way binding.
    def set_aws_profile!
      return if ENV['TEST']
      return unless File.exist?("#{Pipedream.root}/.pipedream/settings.yml") # for rake docs
      return unless settings # Only load if within Pipedream project and there's a settings.yml

      data = settings || {}
      if data[:aws_profile]
        puts "Using AWS_PROFILE=#{data[:aws_profile]} from PIPE_ENV=#{Pipedream.env} in config/settings.yml"
        ENV['AWS_PROFILE'] = data[:aws_profile]
      end
    end

    def settings
      Setting.new.data
    end
    memoize :settings

    def check_pipedream_project!
      check_path = "#{Pipedream.root}/.pipedream"
      unless File.exist?(check_path)
        puts "ERROR: No .pipedream folder found.  Are you sure you are in a project with pipedream setup?".color(:red)
        puts "Current directory: #{Dir.pwd}"
        puts "If you want to set up pipedream for this prjoect, please create a settings file via: pipe init"
        exit 1 unless ENV['TEST']
      end
    end

  private
    def env_from_profile
      Pipedream::Setting.new.pipe_env
    end
  end
end
