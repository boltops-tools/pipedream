module Pipedream::Dsl
  module Webhook
    include Ssm

    # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codepipeline-webhook.html
    PROPERTIES = %w[
      authentication
      authentication_configuration
      filters
      name
      register_with_third_party
      target_action
      target_pipeline
      target_pipeline_version
    ]
    PROPERTIES.each do |prop|
      define_method(prop) do |v|
        @properties[prop.to_sym] = v
      end
    end

    def secret_token(v)
      @secret_token = v
    end
    alias_method :github_token, :secret_token
  end
end
