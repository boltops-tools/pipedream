module Pipedream
  class Sns
    include Pipedream::Dsl::Sns
    include Evaluate

    def initialize(options={})
      @options = options
      @sns_path = options[:sns_path] || get_sns_path
      @properties = default_properties
    end

    def run
      evaluate(@sns_path) if File.exist?(@sns_path)

      resource = {
        sns_topic: {
          type: "AWS::SNS::Topic",
          properties: @properties
        }
      }
      CfnCamelizer.transform(resource)
    end

    def default_properties
      display_name = "#{@options[:full_pipeline_name]} pipeline"
      {
        display_name: display_name,
        # kms_master_key_id: "string",
        # subscription: [{
        #   endpoint: '',
        #   protocol: ','
        # }],
        # topic_name: "string", # Not setting because update requires: Replacement. Dont want 2 pipelines to collide
      }
      # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-sns-subscription.html
    end

  private
    def get_sns_path
      lookup_codepipeline_file("sns.rb")
    end
  end
end
