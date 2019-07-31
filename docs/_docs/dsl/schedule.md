---
title: Schedule DSL
nav_text: Schedule
categories: dsl
nav_order: 16
---

The codepipeline tool supports creating a CloudWatch scheduled event rule that will trigger the codepipeline project periodically.  You define the schedule in `.codepipeline/schedule.rb`. Here's an example of what that looks like:

.codepipeline/schedule.rb:

```ruby
rate "1 day"
# or
# cron("0 10 * * ? *") # Run at 10:00 am (UTC) every day
```

## Full DSL

The convenience methods merely wrap properties of the [AWS::Events::Rule](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-events-rule.html#cfn-events-rule-description).  If you wanted to set the CloudFormation properties more directly, here's an example of using the Full DSL.

.codepipeline/schedule.rb:

```ruby
description "my description"
schedule_expression "rate(1 day)"
```

{% include prev_next.md %}
