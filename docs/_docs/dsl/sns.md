---
title: Sns Topic DSL
nav_text: Sns Topic
categories: dsl
nav_order: 16
---

The codepipeline tool can optionally create an SNS Topic and associate it with your [Approval Action]({% link _docs/dsl/approve.md %}).
If you have created an Approval Action in the pipeline with the `approve` method, then the codepipeline tool will create and manage the SNS topic for you.

For most cases, the default SNS topic should suffice. However, if you wish to control the SNS topic properties you can do so with a `.codepipeline/sns.rb` file.  Here's an example:

```ruby
display_name "my display_name"
kms_master_key_id "String"
# subscription([{
#   endpoint: '',
#   protocol: ','
# }])
topic_name "string", # Recommend not setting because update requires: Replacement. Allow CloudFormation to set it so 2 pipelines dont have same SNS Topic name that collides
```

The methods in the `sns.rb` are simply properties of the [SNS::Topic](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-sns-topic.html) CloudFormation Resource

Note: The codepipeline tool will only create the SNS Topic if you have declared an Approval Action in the `pipeline.rb` without specifying an existing SNS Topic ARN.

{% include prev_next.md %}