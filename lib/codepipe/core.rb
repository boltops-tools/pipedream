require 'pathname'
require 'yaml'
require 'active_support/core_ext/string'

module Codepipe
  module Core
    extend Memoist

    def root
      path = ENV['CB_ROOT'] || '.'
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

    # Overrides AWS_PROFILE based on the Codepipe.env if set in configs/settings.yml
    # 2-way binding.
    def set_aws_profile!
      return if ENV['TEST']
      return unless File.exist?("#{Codepipe.root}/.codepipeline/settings.yml") # for rake docs
      return unless settings # Only load if within Codepipe project and there's a settings.yml
      data = settings[Codepipe.env] || {}
      if data["aws_profile"]
        puts "Using AWS_PROFILE=#{data["aws_profile"]} from PIPE_ENV=#{Codepipe.env} in config/settings.yml"
        ENV['AWS_PROFILE'] = data["aws_profile"]
      end
    end

    def settings
      Setting.new.data
    end
    memoize :settings

    def check_codepipeline_project!
      check_path = "#{Codepipe.root}/.codepipeline"
      unless File.exist?(check_path)
        puts "ERROR: No .codepipeline folder found.  Are you sure you are in a project with codepipeline setup?".color(:red)
        puts "Current directory: #{Dir.pwd}"
        puts "If you want to set up codepipeline for this prjoect, please create a settings file via: codepipeline init"
        exit 1 unless ENV['TEST']
      end
    end

  private
    def env_from_profile
      Codepipe::Setting.new.pipe_env
    end
  end
end
