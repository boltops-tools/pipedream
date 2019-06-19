module Codepipe::Dsl
  module Pipeline
    include Codebuild

    def stage(name, &block)
      @current_stage = {name: name, actions: []}
      @run_order = 1
      @stages << @current_stage
      block.call
    end

    def action(*props)
      @current_stage[:actions] += props
      @run_order += 1
    end
  end
end