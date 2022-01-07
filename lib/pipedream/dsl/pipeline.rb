module Pipedream::Dsl
  module Pipeline
    include Approve
    include Codebuild
    include Github
    include Ssm

    PROPERTIES = %w[
      artifact_store
      artifact_stores
      disable_inboundstage_transitions
      input_artifacts
      name
      restart_execution_on_update
      role_arn
      stages
    ]
    PROPERTIES.each do |prop|
      define_method(prop) do |v|
        @properties[prop.to_sym] = v
      end
    end

    def pipeline_name
      @options[:pipeline_name]
    end

    def stage(name, &block)
      # Reset values for each stage declaraion
      @run_order = 1

      @current_stage = {name: name, actions: []}
      @stages << @current_stage
      block.call
    end

    def in_parallel
      @in_parallel = true
      yield
      @in_parallel = false
    end

    def action(*props)
      @current_stage[:actions] += props
      @run_order += 1 unless @in_parallel
    end
  end
end