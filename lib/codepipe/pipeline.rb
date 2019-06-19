module Codepipe
  class Pipeline
    include Evaluate
    include Dsl::Pipeline

    def initialize(options={})
      @options = options
      @pipeline_path = options[:pipeline_path] || get_pipeline_path
      @properties = default_properties # defaults make pipeline.rb simpler
      @stages = []
    end

    def run
      evaluate(@pipeline_path)
      puts "STAGES:"
      pp @stages

      resource = {
        code_build: {
          type: "AWS::CodePipeline::Pipeline",
          properties: @properties
        }
      }
      CfnCamelizer.transform(resource)
    end

    def default_properties
      {
        role_arn: { "Fn::GetAtt": "IamRole.Arn" },
      }
    end

    def get_pipeline_path
      lookup_codepipeline_file "pipeline.rb"
    end

    def exist?
      File.exist?(@pipeline_path)
    end
  end
end