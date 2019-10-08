module Pipedream
  class Webhook
    include Pipedream::Dsl::Webhook
    include Evaluate

    def initialize(options={})
      @options = options
      @webhook_path = options[:webhook_path] || get_webhook_path
      @properties = default_properties
    end

    def run
      return unless File.exist?(@webhook_path)

      old_properties = @properties.clone
      evaluate(@webhook_path)
      set_secret_token!
      return if old_properties == @properties # empty webhook.rb file

      resource = {
        webhook: {
          type: "AWS::CodePipeline::Webhook",
          properties: @properties
        }
      }
      CfnCamelizer.transform(resource)
    end

    def default_properties
      {
        authentication: 'GITHUB_HMAC', # GITHUB_HMAC, IP and UNAUTHENTICATED
        authentication_configuration: {
           secret_token: @secret_token,
        },
        filters: [{
          json_path: "$.ref",
          match_equals: "refs/heads/{Branch}",
        }],
        # name: '', # optional
        register_with_third_party: 'true', # optional
        target_action: 'Source',
        target_pipeline: {ref: "Pipeline"},
        target_pipeline_version: {"Fn::GetAtt": "Pipeline.Version"},
      }
    end

    def set_secret_token!
      @properties.merge!(
        authentication_configuration: {
          secret_token: @secret_token
        }
      )
    end
  private

    def get_webhook_path
      lookup_pipedream_file("webhook.rb")
    end
  end
end
