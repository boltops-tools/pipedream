---
title: SNS Topic DSL
nav_text: Sns Topic
categories: dsl
nav_order: 16
---

Pipe Dream will create an SNS Topic and associate it with your [Approval Action]({% link _docs/dsl/pipeline/approve.md %}) automatically.
For example, if you have created an Approval Action in the pipeline with the `approve` method, then pipedream will create and manage the SNS topic for you.

For most cases, the default SNS topic should suffice. However, if you wish to control the SNS topic properties you can do so with a `.pipedream/sns.rb` file.  By declaring your own SNS topic, pipedream will use yours instead of the default one it usually creates. Here's an example:

```ruby
display_name "my display_name"
kms_master_key_id "String"
subscription([{
  endpoint: 'my@email.com',
  protocol: 'email', # protocol values: https://docs.aws.amazon.com/sns/latest/api/API_Subscribe.html
}])
# topic_name "my-topic", # Recommend not setting because update requires: Replacement. Allow CloudFormation to set it so 2 pipelines dont have same SNS Topic name that collides
```

The methods in the `sns.rb` are simply properties of the [SNS::Topic](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-sns-topic.html) CloudFormation Resource

Note: Pipe Dream will only create the SNS Topic if you have declared an Approval Action in the `pipeline.rb` without specifying an existing SNS Topic ARN.

{% include prev_next.md %}
