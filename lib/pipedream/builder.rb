module Pipedream
  class Builder < Pipedream::CLI::Base
    def initialize(options={})
      super
      @template = {
        "Description" => "CodePipeline Project: #{@full_pipeline_name}",
        "Resources" => {}
      }
    end

    def template
      pipeline = Pipeline.new(@options).build
      @template["Resources"].merge!(pipeline)

      if pipeline["Pipeline"]["Properties"]["RoleArn"] == {"Fn::GetAtt"=>"IamRole.Arn"}
        role = IamRole.new(@options).build
        @template["Resources"].merge!(role)
      end

      if sns_topic?(pipeline)
        sns = Sns.new(@options).build
        @template["Resources"].merge!(sns)
      end

      webhook = Webhook.new(@options).build
      @template["Resources"].merge!(webhook) if webhook

      schedule = Schedule.new(@options).build
      @template["Resources"].merge!(schedule) if schedule

      # https://stackoverflow.com/questions/24508364/how-to-emit-yaml-in-ruby-expanding-aliases
      # Ensure no YAML aliases
      @template = YAML.load(@template.to_json)

      write
      @template
    end

    def write
      template_path = ".pipedream/output/template.yml"
      FileUtils.mkdir_p(File.dirname(template_path))
      IO.write(template_path, YAML.dump(@template))
      logger.info "Template built: #{pretty_path(template_path)}"
    end

    def sns_topic?(template)
      stages = template['Pipeline']['Properties']['Stages']
      stages.detect do |stage|
        stage['Actions'].detect do |action|
          action['Configuration']['NotificationArn'] == {'Ref'=>'SnsTopic'}
        end
      end
    end

  end
end