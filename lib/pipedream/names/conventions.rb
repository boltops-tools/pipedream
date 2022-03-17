module Pipedream::Names
  module Conventions
    def pipeline_name_convention(name_base)
      items = [@pipeline_name, @options[:type], Pipedream.env_extra]
      items.insert(2, Pipedream.env) if Pipedream.config.names.append_env
      items.reject(&:blank?).compact.join("-")
    end

    def inferred_pipeline_name
      # Essentially the project's parent folder
      File.basename(Dir.pwd).gsub('_','-').gsub(/\.+/,'-').gsub(/[^0-9a-zA-Z,-]/, '')
    end

    # Examples:
    #
    #     myapp-ci-deploy # with Settings stack_naming append_env set to false.
    #     myapp-ci-deploy-dev
    #     myapp-ci-deploy-dev-2
    #
    def inferred_stack_name(pipeline_name)
      items = [pipeline_name, @options[:type], Pipedream.env_extra, "pipe"]
      append_env = Pipedream.config.names.append_env
      items.insert(2, Pipedream.env) if append_env
      items.reject(&:blank?).compact.join("-")
    end
  end
end

