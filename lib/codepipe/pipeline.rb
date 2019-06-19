module Codepipe
  class Pipeline
    include Evaluate
    include Dsl::Pipeline

    def initialize(options={})
      @options = options
      @project_path = options[:project_path] || get_project_path
    end

    def run
      evaluate(@project_path)
    end

    def get_project_path
      lookup_codepipeline_file "pipeline.rb"
    end
  end
end