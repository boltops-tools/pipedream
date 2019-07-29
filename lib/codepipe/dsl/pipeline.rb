module Codepipe::Dsl
  module Pipeline
    include Codebuild
    include Github
    include Ssm

    PROPERTIES = %w[
      artifact_store
      artifact_stores
      disable_inboundstage_transitions
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

    def stage(name, &block)
      # Reset values for each stage declaraion
      @run_order = 1

      @current_stage = {name: name, actions: []}
      @stages << @current_stage
      block.call
    end

    def action(*props)
      @current_stage[:actions] += props
      @run_order += 1
    end
  end
end