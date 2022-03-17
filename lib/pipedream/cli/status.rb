class Pipedream::CLI
  class Status < Base
    def run
      # puts "@pipeline_name #{@pipeline_name}"
      # puts "@full_pipeline_name #{@full_pipeline_name}"

      # execution_id = recent_execution_id
      # puts "Most recent execution_id: #{execution_id}"

      resp = codepipeline.get_pipeline_state(name: @full_pipeline_name)
      # puts YAML.dump(resp.to_h.deep_stringify_keys)

      resp.stage_states.each do |state|
        show_stage(state)
      end
    end

    # Stage name
    #   Action name 1
    #   Action name 2 etc
    #
    # Source action has a summary with the commit message.
    # Other actions dont
    #
    #
    def show_stage(stage)
      puts "Stage: #{stage.stage_name}".color(:green)
      stage.action_states.each do |action|
        line = event_time(action.latest_execution.last_status_change)
        line << " Action #{action.action_name}"
        line << " Status #{action.latest_execution.status}"
        line << " Summary #{action.latest_execution.summary}" if action.latest_execution.respond_to?(:summary)
        puts line
      end
    end

    # https://stackoverflow.com/questions/18000432/rails-12-hour-am-pm-range-for-a-day
    def event_time(timestamp)
      Time.parse(timestamp.to_s).localtime.strftime("%I:%M:%S%p")
    end

    def recent_execution_id
      resp = codepipeline.list_pipeline_executions(pipeline_name: @full_pipeline_name)
      execution = resp.pipeline_execution_summaries.first
      execution.pipeline_execution_id if execution
    end
  end
end
