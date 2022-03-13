class Pipedream::Builder
  class Pipeline < Pipedream::Dsl::Base
    include Pipedream::Dsl::Pipeline

    def initialize(options={})
      super
      @stages = []
    end

    def build
      check_exist!

      evaluate_file(pipeline_path)
      @properties[:Stages] ||= @stages
      set_source_branch!

      resource = {
        Pipeline: {
          Type: "AWS::CodePipeline::Pipeline",
          Properties: @properties
        }
      }
      auto_camelize(resource)
    end

    def default_properties
      {
        Name: @full_pipeline_name,
        RoleArn: { "Fn::GetAtt": "IamRole.Arn" },
        ArtifactStore: {
          Type: "S3",
          Location: s3_bucket, # auto creates s3 bucket
        }
      }
    end

    # cli branch option always takes highest precedence
    def set_source_branch!
      return unless @options[:branch]

      source_stage = @properties[:Stages].first
      action = source_stage[:Actions].first
      action[:Configuration][:Branch] = @options[:branch]
    end

    def s3_bucket
      S3Bucket.name
    end

  private
    def check_exist!
      return if File.exist?(pipeline_path)
      puts "ERROR: pipeline does not exist: #{pipeline_path}".color(:red)
      exit 1
    end

    def pipeline_path
      lookup_pipedream_file "pipeline.rb"
    end
  end
end
