module Codepipe::Dsl
  module Pipeline
    include Codebuild
    include Ssm

    PROPERTIES = %w[
      action_type_id
      configuration
      input_artifacts
      name
      output_artifacts
      region
      role_arn
      run_order
    ]
    PROPERTIES.each do |prop|
      define_method(prop) do |v|
        @properties[prop.to_sym] = v
      end
    end

    def stage(name, &block)
      # Reset values for each stage declaraion
      @run_order, @codebuild_prefix, @codebuild_suffix = 1, nil, nil

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