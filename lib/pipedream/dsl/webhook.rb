module Pipedream::Dsl
  module Webhook
    include Ssm

    # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codepipeline-webhook.html
    PROPERTIES = %w[
      Authentication
      AuthenticationConfiguration
      Filters
      Name
      RegisterWithThirdParty
      TargetAction
      TargetPipeline
      TargetPipelineVersion
    ]
    PROPERTIES.each do |prop|
      define_method(prop.underscore) do |v|
        @properties[prop.to_sym] = v
      end
    end

    def secret_token(v)
      @secret_token = v
    end
    alias_method :github_token, :secret_token

    def target_action(v)
      @target_action = v
    end
  end
end
