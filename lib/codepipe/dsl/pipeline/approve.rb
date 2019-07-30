module Codepipe::Dsl::Pipeline
  module Approve
    def approve(props)
      default = {
        name: "approve",
        action_type_id: {
          category: "Approval",
          owner: "AWS",
          provider: "Manual",
          version: "1",
        },
        run_order: @run_order,
        configuration: {  # required: will be set
          notification_arn: {ref: "SnsTopic"}, # defaults to generated SNS topic
        },
      }

      # Normalize special options. Simple approach of setting the default
      case props
      when String, Symbol
        default[:configuration][:custom_data] = props
        props = {}
      when Hash
        default[:configuration][:notification_arn] = props.delete(:notification_arn) if props.key?(:notification_arn)
        default[:configuration][:custom_data] = props.delete(:custom_data) if props.key?(:custom_data)
      else
        raise "Invalid props type: #{props.class}"
      end

      options = default.merge(props)
      action(options)
    end
  end
end
