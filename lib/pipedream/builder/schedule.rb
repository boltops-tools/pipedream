class Pipedream::Builder
  class Schedule < Pipedream::Dsl::Base
    include Pipedream::Dsl::Schedule

    def build
      return unless File.exist?(schedule_path)

      old_properties = @properties.clone
      evaluate_file(schedule_path)

      @properties[:ScheduleExpression] = @schedule_expression if @schedule_expression
      set_rule_event! if @rule_event_props
      return if old_properties == @properties # empty schedule.rb file

      resource = {
        EventsRule: {
          Type: "AWS::Events::Rule",
          Properties: @properties
        },
        EventsRuleRole: events_rule_role,
      }
      auto_camelize(resource)
    end

    def set_rule_event!
      props = @rule_event_props
      if props.key?(:Detail)
        description = props.key?(:Description) ? props.delete(:Description) : rule_description
        rule_props = { EventPattern: props, Description: description }
      else # if props.key?(:EventPattern)
        props[:Description] ||= rule_description
        rule_props = props
      end

      @properties.merge!(rule_props)
    end

    def default_properties
      description = "CodePipeline #{@options[:full_pipeline_name]}"
      name = description.gsub(" ", "-").downcase
      {
        Description: description,
        # EventPattern: ,
        Name: name,
        # schedule_expression: ,
        State: "ENABLED",
        Targets: [{
          Arn: "arn:aws:codepipeline:#{aws.region}:#{aws.account}:#{@options[:full_pipeline_name]}",
          RoleArn: { "Fn::GetAtt": "EventsRuleRole.Arn" }, # required for specific CodePipeline target.
          Id: "CodePipelineTarget",
        }]
      }
    end

  private
    def schedule_path
      lookup_pipedream_file("schedule.rb")
    end

    def events_rule_role
      text =<<~EOL
        ---
        Type: AWS::IAM::Role
        Properties:
          AssumeRolePolicyDocument:
            Statement:
            - Action:
              - sts:AssumeRole
              Effect: Allow
              Principal:
                Service:
                - events.amazonaws.com
            Version: '2012-10-17'
          Path: "/"
          Policies:
          - PolicyName: CodePipelineAccess
            PolicyDocument:
              Version: '2012-10-17'
              Statement:
              - Action: codepipeline:StartPipelineExecution
                Effect: Allow
                Resource: arn:aws:codepipeline:#{aws.region}:#{aws.account}:#{@options[:full_pipeline_name]}
      EOL
      YAML.load(text)
    end
  end
end
