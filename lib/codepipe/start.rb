module Codepipe
  class Start
    extend Memoist
    include AwsServices

    def initialize(options)
      @options = options
      @pipeline_name = options[:pipeline_name] || inferred_pipeline_name
      @full_pipeline_name = pipeline_name_convention(@pipeline_name)
      @stack_name = options[:stack_name] || inferred_stack_name(@pipeline_name)
    end

    def run
      resp = codepipeline.start_pipeline_execution(name: pipeline_name)
      codepipeline_info(resp.pipeline_execution_id)
    end

    def pipeline_name
      if pipeline_exists?(@full_pipeline_name)
        @full_pipeline_name
      elsif stack_exists?(@stack_name) # allow `cb start STACK_NAME` to work too
        resp = cfn.describe_stack_resources(stack_name: @stack_name)
        resource = resp.stack_resources.find do |r|
          r.logical_resource_id == "CodePipeline"
        end
        resource.physical_resource_id # codepipeline project name
      else
        puts "ERROR: Unable to find the codepipeline project with either full_pipeline_name: #{@full_pipeline_name} or stack name: #{@stack_name}".color(:red)
        exit 1
      end
    end
    memoize :pipeline_name

  private
    def codepipeline_info(execution_id)
      region = `aws configure get region`.strip rescue "us-east-1"
      url = "https://#{region}.console.aws.amazon.com/codesuite/codepipeline/pipelines/#{pipeline_name}/view"
      cli = "aws codepipeline get-pipeline-execution --pipeline-execution-id #{execution_id} --pipeline-name #{pipeline_name}"

      puts "Pipeline started: #{pipeline_name}"
      puts "Please check the CodePipeline console for the status."
      puts "CodePipeline Console: #{url}"
      puts "Pipeline cli: #{cli}"
    end

    def pipeline_exists?(name)
      codepipeline.get_pipeline(name: name)
      true
    rescue Aws::CodePipeline::Errors::PipelineNotFoundException
      false
    end
  end
end
