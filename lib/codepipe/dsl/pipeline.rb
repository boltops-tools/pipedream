module Codepipe::Dsl
  module Pipeline
    def stage(name)
      yield
    end

    def action(props)
      pp props
    end
  end
end