---
title: CodePipeline DSL
nav_order: 9
---

CodePipeline provides a simple yet powerful DSL to create CodePipeline related resources.  Here's an example:

```ruby
stage "Source" do
  github(
    source: "tongueroo/demo-test",
    auth_token: ssm("/github/user/token")
  )
end

stage "Build" do
  codebuild "demo1", "demo2"
  codebuild "demo3"
end

stage "Approve" do
  approve("Approve this deploy")
end

stage "Deploy" do
  codebuild "deploy"
end
```

Here are some examples of resources it can create:

* [pipeline]({% link _docs/dsl/pipeline.md %}): The CodePipeline pipeline. This is required.
* [iam role]({% link _docs/dsl/role.md %}): The IAM role associated with the CodePipeline pipeline.
* [webhook]({% link _docs/dsl/webhook.md %}): The webhook associated with the CodePipeline pipeline.
* [schedule]({% link _docs/dsl/schedule.md %}): An CloudWatch Event rule: triggers the pipeline to start on a scheduled basis.
* [sns topic]({% link _docs/dsl/sns.md %}): The SNS Topic associated with the approval step. This is optional and provides a way to customize the SNS topic if needed.

{% include prev_next.md %}
