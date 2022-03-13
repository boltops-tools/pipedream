class Pipedream::Builder
  class Webhook < Pipedream::Dsl::Base
    include Pipedream::Dsl::Webhook

    def build
      return unless File.exist?(webhook_path)

      old_properties = @properties.clone
      evaluate_file(webhook_path)
      @properties.merge!(evaluated_properties)
      return if old_properties == @properties # empty webhook.rb file

      resource = {
        Webhook: {
          Type: "AWS::CodePipeline::Webhook",
          Properties: @properties
        }
      }
      auto_camelize(resource)
    end

    def default_properties
      {
        Authentication: 'GITHUB_HMAC', # GITHUB_HMAC, IP and UNAUTHENTICATED
        Filters: [{
          JsonPath: "$.ref",
          MatchEquals: "refs/heads/{Branch}",
        }],
        # Name: '', # optional
        RegisterWithThirdParty: 'true', # optional
        TargetPipeline: {Ref: "Pipeline"},
        TargetPipelineVersion: {"Fn::GetAtt": "Pipeline.Version"},
      }
    end

    def evaluated_properties
      {
        AuthenticationConfiguration: {
           SecretToken: @secret_token,
        },
        TargetAction: @target_action || 'Main',
      }
    end

  private
    def webhook_path
      lookup_pipedream_file("webhook.rb")
    end
  end
end
