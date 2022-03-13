module Pipedream::Dsl::Pipeline
  module Approve
    def approve(props)
      default = {
        Name: "approve",
        ActionTypeId: {
          Category: "Approval",
          Owner: "AWS",
          Provider: "Manual",
          Version: "1",
        },
        RunOrder: @run_order,
        Configuration: {  # required: will be set
          NotificationArn: {Ref: "SnsTopic"}, # defaults to generated SNS topic
        },
      }

      # Normalize special options. Simple approach of setting the default
      case props
      when String, Symbol
        default[:Configuration][:CustomData] = props
        props = {}
      when Hash
        default[:Configuration][:NotificationArn] = props.delete(:NotificationArn) if props.key?(:NotificationArn)
        default[:Configuration][:CustomData] = props.delete(:CustomData) if props.key?(:CustomData)
      else
        raise "Invalid props type: #{props.class}"
      end

      options = default.merge(props)
      action(options)
    end
  end
end
