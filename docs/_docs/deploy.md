---
title: Deploy
nav_order: 4
---

The pipeline is generated from the DSL and created with CloudFormation. By default, the files that the DSL evaluates are:

    .codepipeline/pipeline.rb
    .codepipeline/role.rb
    .codepipeline/schedule.rb
    .codepipeline/webhook.rb

To create the CodePipeline pipeline, you run:

    codepipeline deploy

You'll see output that looks something like this:

    $ pipe deploy
    Generated CloudFormation template at /tmp/codepipeline.yml
    Deploying stack demo-pipe with CodePipeline project demo
    Creating stack demo-pipe. Check CloudFormation console for status.
    Stack name demo-pipe status CREATE_IN_PROGRESS
    Here's the CloudFormation url to check for more details https://console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks
    Waiting for stack to complete
    04:14:03AM CREATE_IN_PROGRESS AWS::CloudFormation::Stack demo-pipe User Initiated
    04:14:06AM CREATE_IN_PROGRESS AWS::IAM::Role IamRole
    04:14:07AM CREATE_IN_PROGRESS AWS::IAM::Role IamRole Resource creation Initiated
    04:14:25AM CREATE_COMPLETE AWS::IAM::Role IamRole
    04:14:28AM CREATE_IN_PROGRESS AWS::CodePipeline::Pipeline Pipeline
    04:14:29AM CREATE_IN_PROGRESS AWS::CodePipeline::Pipeline Pipeline Resource creation Initiated
    04:14:29AM CREATE_COMPLETE AWS::CodePipeline::Pipeline Pipeline
    04:14:31AM CREATE_IN_PROGRESS AWS::CodePipeline::Webhook Webhook
    04:14:33AM CREATE_IN_PROGRESS AWS::CodePipeline::Webhook Webhook Resource creation Initiated
    04:14:33AM CREATE_COMPLETE AWS::CodePipeline::Webhook Webhook
    04:14:35AM CREATE_COMPLETE AWS::CloudFormation::Stack demo-pipe
    Stack success status: CREATE_COMPLETE
    Time took for stack deployment: 35s.
    $

## Explicit Pipeline Name

By default, the pipeline name is inferred and is the parent folder that you are within.  You can explicitly specify the pipeline name as the first CLI argument:

    pipe deploy my-pipeline

## Specify Git Branch

It is useful to build pipelines with different source git branches. You can pass a `--branch` option to the `pipe deploy` command. In the `.codepipeline/pipeline.rb` use the DSL method `branch` to reference it.  Example:

    pipe deploy my-pipeline --branch my-branch

.codepipeline/pipeline.rb

```ruby
stage "Source" do
  github(
    source: "tongueroo/demo-test",
    auth_token: ssm("/github/user/token")
  )
end
```

Note: Currently CodePipeline does not support specifying a source git branch at runtime. We can only specific it as part of the pipeline definition.


## CLI Reference

Also, for help info you can check the [pipe deploy]({% link _reference/pipe-deploy.md %}) CLI reference.

{% include prev_next.md %}