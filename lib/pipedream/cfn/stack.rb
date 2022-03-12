module Pipedream::Cfn
  class Stack < Pipedream::CLI::Base
    def run
      @template = Pipedream::Builder.new(@options).template
      puts "Deploying stack #{@stack_name.color(:green)} with CodePipeline project #{@full_pipeline_name.color(:green)}"

      begin
        perform
        url_info
        return unless @options[:wait]
        status.wait
        exit 2 unless status.success?
      rescue Aws::CloudFormation::Errors::ValidationError => e
        if e.message.include?("No updates") # No updates are to be performed.
          puts "WARN: #{e.message}".color(:yellow)
        else
          puts "ERROR ValidationError: #{e.message}".color(:red)
          exit 1
        end
      end
    end

  private
    def sns_topic?(template)
      stages = template['Pipeline']['Properties']['Stages']
      stages.detect do |stage|
        stage['Actions'].detect do |action|
          action['Configuration']['NotificationArn'] == {'Ref'=>'SnsTopic'}
        end
      end
    end

    def url_info
      stack = cfn.describe_stacks(stack_name: @stack_name).stacks.first
      region = `aws configure get region`.strip rescue "us-east-1"
      url = "https://console.aws.amazon.com/cloudformation/home?region=#{region}#/stacks"
      puts "Stack name #{@stack_name.color(:yellow)} status #{stack["stack_status"].color(:yellow)}"
      puts "Here's the CloudFormation url to check for more details #{url}"
    end

    def status
      @status ||= Cfn::Status.new(@stack_name)
    end
  end
end
