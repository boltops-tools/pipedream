---
title: Approval Action DSL
nav_text: Approve
categories: dsl-pipeline
nav_order: 12
---

You can add an Approval Action to a Stage with the `approve` method.  There are various helpful forms. Let's start with the simplest form.

## String Form

The approve method take can take a simple String. In this form, it sets the message for the approval action.  Essentially, it sets the `configuration.CustomData` property of the Approval action.  See [Add an Action to a Pipeline in CodePipeline](https://docs.aws.amazon.com/codepipeline/latest/userguide/approvals-action-add.html) docs for the full structure.

```ruby
stage "Approve" do
  approve("Approve this deployment")
end
```

With CodePipeline, an SNS topic is required to be associated with the Approval Action. In the case of a String form, pipedream will automatically create and manage the SNS topic associated with the `approve` declaration.

## Simplified Configuration Hash Form

If the `approve` method is provided a Hash with the `notification_arn` and `custom_data`, then pipedream will set the `configuration` directly. Example:

```ruby
stage "Approve" do
  approve(
    notification_arn: "arn:aws:sns:us-west-2:112233445566:hello-topic",
    custom_data: "Approve deployment",
  )
end
```

In this case, the Pipe Dream will *not* create an SNS Topic as we're have specified an existing SNS topic.

## Full Config Form

The convenience methods merely wrap a CodePipeline Approval Action.  An example of the Approval Action structure is provided in the [Add an Action to a Pipeline in CodePipeline](https://docs.aws.amazon.com/codepipeline/latest/userguide/approvals-action-add.html) docs.

If you need to set the properties more directly, here's an example of using the "Full" Config.

```ruby
stage "Approve" do
  approve(
    name: "approve",
    action_type_id: {
      category: "Approval",
      owner: "AWS",
      provider: "Manual",
      version: "1",
    },
    run_order: 1,
    configuration: {
      custom_data: "my message",
      notification_arn: {ref: "SnsTopic"}, # defaults to generated SNS topic
    },
  )
end
```

{% include prev_next.md %}
