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
      @properties[:stages] ||= @stages
      set_source_branch!

      resource = {
        pipeline: {
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

    # cli branch option always takes highest precedence
    def set_source_branch!
      return unless @options[:branch]

      source_stage = @properties[:stages].first
      action = source_stage[:actions].first
      action[:configuration][:branch] = @options[:branch]
    end

    def exist?
      File.exist?(@pipeline_path)
    end

    def s3_bucket
      S3Bucket.name
    end

  private
    def get_pipeline_path
      lookup_codepipeline_file "pipeline.rb"
    end
  end
end
