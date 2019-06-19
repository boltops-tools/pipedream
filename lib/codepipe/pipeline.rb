module Codepipe
  class Pipeline
    extend Memoist
    include Dsl::Pipeline
    include Evaluate

    def initialize(options={})
      @options = options
      @pipeline_path = options[:pipeline_path] || get_pipeline_path
      @properties = default_properties # defaults make pipeline.rb simpler
      @stages = []
    end

    def run
      evaluate(@pipeline_path)
      @properties[:stages] = @stages

      resource = {
        code_pipeline: {
          type: "AWS::CodePipeline::Pipeline",
          properties: @properties
        }
      }
      CfnCamelizer.transform(resource)
    end

    def default_properties
      {
        name: @options[:full_pipeline_name],
        role_arn: { "Fn::GetAtt": "IamRole.Arn" },
        artifact_store: {
          type: "S3",
          location: s3_bucket, # auto creates s3 bucket
        }
      }
    end

    def s3_bucket
      S3Bucket.name
    end

    def get_pipeline_path
      lookup_codepipeline_file "pipeline.rb"
    end

    def exist?
      File.exist?(@pipeline_path)
    end
  end
end
