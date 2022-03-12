class Pipedream::Builder
  class Pipeline < Pipedream::Dsl::Base
    include Dsl::Pipeline

    def initialize(options={})
      super
      @stages = []
    end

    def run
      evaluate_path(pipeline_path)
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
      File.exist?(pipeline_path)
    end

    def s3_bucket
      S3Bucket.name
    end

  private
    def pipeline_path
      lookup_pipedream_file "pipeline.rb"
    end
  end
end
