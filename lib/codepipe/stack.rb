require "aws-sdk-cloudformation"

module Codepipe
  class Stack
    include AwsServices

    def initialize(options)
      @options = options
      @pipeline_name = @options[:pipeline_name] || inferred_pipeline_name
      @stack_name = options[:stack_name] || inferred_stack_name(@pipeline_name)

      @full_pipeline_name = pipeline_name_convention(@pipeline_name)
      @template = {
        "Description" => "CodePipeline Project: #{@full_pipeline_name}",
        "Resources" => {}
      }
    end

    def run
      options = @options.merge(
        pipeline_name: @pipeline_name,
        full_pipeline_name: @full_pipeline_name,
      )

      pipeline_builder = Pipeline.new(options)
      unless pipeline_builder.exist?
        puts "ERROR: Codepipe pipeline does not exist: #{pipeline_builder.pipeline_path}".color(:red)
        exit 1
        return
      end
      pipeline = pipeline_builder.run
      @template["Resources"].merge!(pipeline)

      if pipeline["CodePipeline"]["Properties"]["RoleArn"] == {"Fn::GetAtt"=>"IamRole.Arn"}
        role = Role.new(options).run
        @template["Resources"].merge!(role)
      end

      schedule = Schedule.new(options).run
      @template["Resources"].merge!(schedule) if schedule

      template_path = "/tmp/codepipeline.yml"
      FileUtils.mkdir_p(File.dirname(template_path))
      IO.write(template_path, YAML.dump(@template))
      puts "Generated CloudFormation template at #{template_path.color(:green)}"
      return if @options[:noop]
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
          puts "ERROR: #{e.message}".color(:red)
          exit 1
        end
      end
    end

  private
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
