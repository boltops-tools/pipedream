module Pipedream::Cfn
  class Stack < Pipedream::CLI::Base
    include Pipedream::AwsServices

    def run
      are_you_sure?
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
    def are_you_sure?
      message = "Will deploy stack #{@stack_name.color(:green)}"
      if @options[:yes]
        logger.info message
      else
        sure?(message)
      end
    end

    def url_info
      stack = cfn.describe_stacks(stack_name: @stack_name).stacks.first
      url = "https://console.aws.amazon.com/cloudformation/home?region=#{region}#/stacks"
      puts "Stack name #{@stack_name.color(:yellow)} status #{stack["stack_status"].color(:yellow)}"
      puts "Here's the CloudFormation url to check for more details #{url}"
    end

    def status
      @status ||= Cfn::Status.new(@stack_name)
    end
  end
end
