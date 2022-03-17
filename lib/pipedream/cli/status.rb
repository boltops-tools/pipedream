class Pipedream::CLI
  class Status < Base
    def run
      # codepipeline.list_pipeline_executions
      puts "@pipeline_name #{@pipeline_name}"
      puts "@full_pipeline_name #{@full_pipeline_name}"
      codepipeline.get_pipeline_state(name: @full_pipeline_name)
    end
  end
end
