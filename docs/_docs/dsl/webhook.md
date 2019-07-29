---
title: Webhook DSL
nav_text: Webhook
categories: dsl
nav_order: 12
---

The simplest way to declare a webhook is to use the `github_token` method. This single line is enough to configure and set up the webhook.

.codepipeline/webhook.rb:

```ruby
github_token(ssm("/codebuild/github/oauth_token"))
```

## Full DSL

The convenience methods merely wrap properties of the [AWS::CodePipeline::Webhook](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codepipeline-webhook.html).  If you wanted to set the CloudFormation properties more directly, here's an example of using the Full DSL.

.codepipeline/webhook.rb:

```ruby
authentication "GITHUB_HMAC"
authentication_configuration(secret_token: ssm("/codebuild/github/oauth_token"))
filters([{
  json_path: "$.ref",
  match_equals: "refs/heads/{Branch}",
}])
```

{% include prev_next.md %}