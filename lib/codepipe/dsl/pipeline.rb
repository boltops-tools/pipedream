module Codepipe::Dsl
  module Pipeline
    include Codebuild

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