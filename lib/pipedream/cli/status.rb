class Pipedream::CLI
  class Status < Base
    def run(execution_id=nil)
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
        get_pipeline_state.stage_states.each do |stage_state|
          show_stage(stage_state)
          show_inbound_waiting(stage_state)
        end
        completed = completed?
        break if completed
        sleep 1 # if dont poll quick enough higher chance of missing the InProgress status
        # sleep 5

        if File.exist?("/tmp/loud.txt")
          resp = codepipeline.get_pipeline_state(name: @full_pipeline_name)
          puts YAML.dump(resp.to_h.deep_stringify_keys)
        end
      end
    end

    def show_stage(stage_state)
      # Filter by execution_id
      if @execution_id
        return unless @execution_id == stage_state.latest_execution.pipeline_execution_id
      end

      header = "Stage #{stage_state.stage_name}"
      if logger.level <= Logger::DEBUG # info is 1 debug is 0
        header << " Execution id #{stage_state.latest_execution.pipeline_execution_id}"
      end
      show(header.color(:purple))
      stage_state.action_states.each do |action|
        latest_execution = action.latest_execution
        next unless latest_execution
        line = event_time(latest_execution.last_status_change)
        line << " #{action.action_name}:"
        line << " Status #{status_color(latest_execution.status)}"
        line << " #{latest_execution.summary}" unless latest_execution.summary.blank?
        line << " #{stage_state.latest_execution.pipeline_execution_id}" # debug
        show line
      end
    end

    # Waiting for the InProgress Stage ahead
    # - stage_name: Deploy
    #   inbound_execution:
    #     pipeline_execution_id: 501e9a69-1f02-43b1-819a-e51e33f453e4
    #     status: InProgress
    def show_inbound_waiting(stage_state)
      return unless stage_state.inbound_execution&.pipeline_execution_id == @execution_id
      # show "Waiting for another #{stage_state.stage_name} stage that's in progress"
      show "Waiting for another in progress stage: #{stage_state.stage_name}"
    end

    # resp.pipeline_execution_summaries[0].status #=> String, one of "Cancelled", "InProgress", "Stopped", "Stopping", "Succeeded", "Superseded", "Failed"
    def completed?
      @execution_id
      resp = codepipeline.list_pipeline_executions(pipeline_name: @full_pipeline_name)
      executions = resp.pipeline_execution_summaries
      execution = executions.find do |e|
        e.pipeline_execution_id == @execution_id
      end
      return false unless execution
      in_progress_statuses = %w[InProgress Stopping]
      !in_progress_statuses.include?(execution.status)
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
