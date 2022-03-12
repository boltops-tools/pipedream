class Pipedream::Builder
  class Webhook < Pipedream::Dsl::Base
    include Pipedream::Dsl::Webhook

    def initialize(options={})
      @options = options
      @properties = default_properties
    end

    def build
      return unless File.exist?(webhook_path)

      old_properties = @properties.clone
      evaluate_file(webhook_path)
      set_secret_token!
      set_target_action_token!
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
        # target_action: @target_action || 'Main',
        target_pipeline: {ref: "Pipeline"},
        target_pipeline_version: {"Fn::GetAtt": "Pipeline.Version"},
      }
    end

    def set_target_action_token!
      @properties[:target_action] = @target_action || 'Main'
    end

    def target_action(value)
      @target_action = value
    end

    def set_secret_token!
      @properties.merge!(
        authentication_configuration: {
          secret_token: @secret_token
        }
      )
    end

  private
    def webhook_path
      lookup_pipedream_file("webhook.rb")
    end
  end
end
