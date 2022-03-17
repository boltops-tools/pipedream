class Pipedream::CLI
  class Status < Base
    def run(execution_id=nil)
      resp = codepipeline.get_pipeline_state(name: @full_pipeline_name)
      puts YAML.dump(resp.to_h.deep_stringify_keys)

      @execution_id = execution_id || recent_execution_id
      show_stages
    end

    # Stage: Source
    # 06:49:59PM Central: Status Succeeded commit message 1
    # 06:50:00PM App: Status Succeeded commit message 2
    # Stage: Deploy
    # 06:55:13PM code-build-job: Status Succeeded
    def show_stages
      completed = false
      until completed do
        pipeline_state = get_pipeline_state
        get_pipeline_state.stage_states.each do |state|
          show_stage(state)
        end
        completed = completed?(pipeline_state)
        break if completed
        sleep 1 # if dont poll quick enough might miss the InProgress status
      end
    end

    def show_stage(stage)
      # Filter by execution_id
      if @execution_id
        # puts "@execution_id #{@execution_id} current execution id #{stage.latest_execution.pipeline_execution_id}"
        return unless @execution_id == stage.latest_execution.pipeline_execution_id
        # if @execution_id == stage.latest_execution.pipeline_execution_id
        #   puts "MATCHES will show stage #{stage.stage_name}".color(:green)
        # else
        #   puts "NO MATCH will NOT show #{stage.stage_name}".color(:red)
        #   return
        # end
      end

      header = "Stage #{stage.stage_name}"
      # if logger.level <= Logger::DEBUG # info is 1 debug is 0
        header << " Execution id #{stage.latest_execution.pipeline_execution_id}"
      # end
      show(header.color(:purple))
      stage.action_states.each do |action|
        latest_execution = action.latest_execution
        next unless latest_execution
        line = event_time(latest_execution.last_status_change)
        line << " #{action.action_name}:"
        line << " Status #{status_color(latest_execution.status)}"
        line << " #{latest_execution.summary}" unless latest_execution.summary.blank?
        line << " #{stage.latest_execution.pipeline_execution_id}" # debug
        show line
      end
    end

    def completed?(pipeline_state)
      in_progress = pipeline_state.stage_states.find do |stage|
        stage.action_states.find do |action|
          action.latest_execution && action.latest_execution.status == "InProgress"
        end
      end
      !in_progress
    end

    def get_pipeline_state
      codepipeline.get_pipeline_state(name: @full_pipeline_name) # resp
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
      logger.info message
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
