class Pipedream::Builder
  class Sns < Pipedream::Dsl::Base
    include Pipedream::Dsl::Sns

    def build
      evaluate_file(sns_path) if File.exist?(sns_path)

      resource = {
        SnsTopic: {
          Type: "AWS::SNS::Topic",
          Properties: @properties
        }
      }
      auto_camelize(resource)
    end

    def default_properties
      display_name = "#{@options[:full_pipeline_name]} pipeline"
      {
        DisplayName: display_name,
        # KmsMasterKeyId: "string",
        # Subscription: [{
        #   Endpoint: '',
        #   Protocol: ','
        # }],
        # TopicName: "string", # Not setting because update requires: Replacement. Dont want 2 pipelines to collide
      }
      # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-sns-subscription.html
    end

  private
    def sns_path
      lookup_pipedream_file("sns.rb")
    end
  end
end
