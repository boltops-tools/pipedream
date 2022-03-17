class Pipedream::CLI
  class Status < Base
    def run
      # puts "@pipeline_name #{@pipeline_name}"
      # puts "@full_pipeline_name #{@full_pipeline_name}"

      # execution_id = recent_execution_id
      # puts "Most recent execution_id: #{execution_id}"

      resp = codepipeline.get_pipeline_state(name: @full_pipeline_name)
      puts YAML.dump(resp.to_h.deep_stringify_keys)

      show_stages
    end

    def show_stages
      completed = false
      until completed do
        pipeline_state = get_pipeline_state
        get_pipeline_state.stage_states.each do |state|
          show_stage(state)
        end
        completed = completed?(pipeline_state)
        break if completed
        sleep 5
      end
    end

    def completed?(pipeline_state)
      in_progress = pipeline_state.stage_states.find do |stage|
        stage.action_states.find do |action|
          action.latest_execution.status == "InProgress"
        end
      end
      !in_progress
    end

    def get_pipeline_state
      codepipeline.get_pipeline_state(name: @full_pipeline_name) # resp
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
      header = "Stage: #{stage.stage_name}"
      header << " Execution id #{stage.latest_execution.pipeline_execution_id}"
      show(header.color(:purple))
      stage.action_states.each do |action|
        line = event_time(action.latest_execution.last_status_change)
        line << " #{action.action_name}:"
        line << " Status #{status_color(action.latest_execution.status)}"
        line << " - #{action.latest_execution.summary}" unless action.latest_execution.summary.blank?
        show line
      end
    end

    def status_color(status)
      case status
      when "InProgress"
        status.color(:yellow)
      when "Succeeded"
        status.color(:green)
      else
        status.color(:red)
      end
    end

    @@shown = []
    def show(message)
      return if @@shown.include?(message)
      puts message
      @@shown << message
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
