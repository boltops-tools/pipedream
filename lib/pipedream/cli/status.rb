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
          next unless current?(stage_state)
          show_stage(stage_state)
          show_error(stage_state)
          show_inbound_waiting(stage_state)
          handle_approval(stage_state)
        end
        completed = completed?
        break if completed
        sleep 1 # if dont poll quick enough higher chance of missing the InProgress status

        if File.exist?("/tmp/loud.txt")
          resp = codepipeline.get_pipeline_state(name: @full_pipeline_name)
          puts YAML.dump(resp.to_h.deep_stringify_keys)
        end
      end
    end

    def show_error(stage_state)
      latest_execution = stage_state.latest_execution
      return unless latest_execution


    end

    def current?(stage_state)
      latest_execution = stage_state.latest_execution
      return false unless latest_execution
      # Filter by execution_id
      if @execution_id
        return false unless @execution_id == latest_execution.pipeline_execution_id
      end
      true
    end

    def show_stage(stage_state)
      latest_execution = stage_state.latest_execution
      header = "Stage #{stage_state.stage_name}"
      if debug?
        header << " Execution id #{latest_execution.pipeline_execution_id}"
      end
      show(header.color(:purple))
      stage_state.action_states.each do |action|
        latest_execution = action.latest_execution
        next unless latest_execution
        has_time = !latest_execution.last_status_change.blank?
        line = has_time ? event_time(latest_execution.last_status_change) : ""
        line << action_name(latest_execution, action)
        line << " Status #{status_color(latest_execution.status)}"
        line << " #{latest_execution.summary}" unless latest_execution.summary.blank?
        line << " #{latest_execution.pipeline_execution_id}" if debug?
        show line
      end
    end

    def action_name(latest_execution, action)
      # puts "=" * 30
      # puts YAML.dump(latest_execution.to_h.deep_stringify_keys)
      # puts YAML.dump(action.to_h.deep_stringify_keys)
      # Approval action does not yet have timestamp
      has_time = !latest_execution.last_status_change.blank?
      text = has_time ? " #{action.action_name}:" : "#{action.action_name}:"
      text
    end


    def handle_approval(stage_state)
      # since put_approval_result is async we can hit this method again too quickly
      return if @handle_approval # @handle_approval prevents that
      latest_execution = stage_state.latest_execution
      return unless latest_execution
      return unless latest_execution.status == "InProgress"

      # Check if its an Approval category
      begin
        resp = codepipeline.list_action_executions(
          pipeline_name: @full_pipeline_name,
          filter: {
            pipeline_execution_id: @execution_id,
          }
        )
      rescue Aws::CodePipeline::Errors::PipelineExecutionNotFoundException => e
        # Because start execution is async, Its possible that list_action_executions is not found
        # initially for a few seconds
        logger.debug "#{e.class}: #{e.message}"
        return
      end

      details = resp.action_execution_details.first
      return unless details # can be nil for a few seconds
      return unless details.input.action_type_id.category == "Approval"

      status = request_approval
      submit_approval(stage_state, status)
      @handle_approval = true # Reaching here means Approved or Rejected
    end

    def submit_approval(stage_state, status)
      action_state = stage_state.action_states.first
      action_name = action_state.action_name
      token = action_state.latest_execution.token
      user = ENV['C9_USER'] || ENV['USER']
      codepipeline.put_approval_result(
        pipeline_name: @full_pipeline_name, # required
        stage_name: stage_state.stage_name, # required
        action_name: action_name, # required
        result: { # required
          summary: "#{status} from pipedream CLI by #{user}", # required
          status: status, # required, accepts Approved, Rejected
        },
        token: token, # required
      )
      if status == "Rejected"
        logger.info "The Stage change pipeline has been rejected."
        exit 1
      end
    end

    def request_approval
      logger.info "Waiting for approval."
      print "Would you like to approve? (yes/no/later) "
      answer = $stdin.gets

      status = case answer
      when /^y/ # yes
        "Approved"
      when /^n/ # no
        "Rejected"
      else
        "Later" # only for pipedream
      end

      if status == "Later"
        logger.info <<~EOL
          You've choosen to approve at a later time.
          You can approve at the CodePipeline console when you're ready.
        EOL
        exit
      end

      status
    end

    def debug?
      logger.level <= Logger::DEBUG # info is 1 debug is 0
    end

    # Waiting for the InProgress Stage ahead
    # - stage_name: Deploy
    #   inbound_execution:
    #     pipeline_execution_id: 501e9a69-1f02-43b1-819a-e51e33f453e4
    #     status: InProgress
    def show_inbound_waiting(stage_state)
      return unless stage_state.inbound_execution&.pipeline_execution_id == @execution_id
      # show "Waiting for another #{stage_state.stage_name} stage that's in progress"
      show "Waiting for another in-progress Stage #{stage_state.stage_name}"
    end

    # resp.pipeline_execution_summaries[0].status #=> String, one of "Cancelled", "InProgress", "Stopped", "Stopping", "Succeeded", "Superseded", "Failed"
    def completed?
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
