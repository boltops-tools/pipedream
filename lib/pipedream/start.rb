module Pipedream
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
      check_pipeline_exists!
      redeploy
      resp = codepipeline.start_pipeline_execution(name: pipeline_name)
      codepipeline_info(resp.pipeline_execution_id)
    end

    # Pipedreamline does not currently support specifying a different branch starting an execution.
    # Workaround this limitation by updating the pipeline and then starting the execution.
    def redeploy
      return unless different_branch?
      puts "Different branch detected."
      puts "  Current pipeline branch: #{current_pipeline_branch}"
      puts "  Requested branch: #{@options[:branch]}"
      puts "Updating pipeline with new branch.".color(:green)
      Deploy.new(@options).run
    end

    def different_branch?
      return false unless @options[:branch]
      current_pipeline_branch != @options[:branch]
    end

    # Actual branch on current pipeline
    def current_pipeline_branch
      resp = codepipeline.get_pipeline(name: pipeline_name)
      source_stage = resp.pipeline.stages.find { |s| s.name == "Source" }
      action = source_stage.actions.first
      action.configuration['Branch']
    end
    memoize :current_pipeline_branch

    def check_pipeline_exists!
      pipeline_name
    end

    def pipeline_name
      if pipeline_exists?(@full_pipeline_name)
        @full_pipeline_name
      elsif stack_exists?(@stack_name) # allow `cb start STACK_NAME` to work too
        resp = cfn.describe_stack_resources(stack_name: @stack_name)
        resource = resp.stack_resources.find do |r|
          r.logical_resource_id == "CodePipeline"
        end
        resource.physical_resource_id # pipeline name
      else
        puts "ERROR: Unable to find the pipeline with either full_pipeline_name: #{@full_pipeline_name} or stack name: #{@stack_name}".color(:red)
        exit 1
      end
    end
    memoize :pipeline_name

  private
    def codepipeline_info(execution_id)
      region = `aws configure get region`.strip rescue "us-east-1"
      url = "https://#{region}.console.aws.amazon.com/codesuite/codepipeline/pipelines/#{pipeline_name}/view"

      puts "Pipeline started: #{pipeline_name}"
      puts "Please check the CodePipeline console for the status."
      puts "CodePipeline Console: #{url}"
      puts "Pipeline cli commands:"
      puts
      puts "    aws codepipeline get-pipeline-execution --pipeline-execution-id #{execution_id} --pipeline-name #{pipeline_name}"
      puts "    aws codepipeline get-pipeline-state --name #{pipeline_name}"
      puts
    end

    def pipeline_exists?(name)
      codepipeline.get_pipeline(name: name)
      true
    rescue Aws::CodePipeline::Errors::PipelineNotFoundException
      false
    end
  end
end
