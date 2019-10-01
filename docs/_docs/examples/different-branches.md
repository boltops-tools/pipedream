---
title: Using Different Branches
nav_text: Different Branches
categories: examples
nav_order: 20
---

CodePipeline currently does not supports starting the pipeline execution with different branches natively. To get around this, we can:

1. update the pipeline before starting it.
2. create additional pipelines.

Pipe Dream supports both methods.

## Update Pipeline Approach

With the update pipeline approach, the pipeline gets updated if the current pipeline branch is different from the requested branch before a pipeline execution starts. Examples:

    pipe start -b master
    pipe start -b qa

Note: With this approach, since the pipeline gets updated, the pipeline will maintain the last branch it was started with.

## Multiple Pipelines Approach

You might normally set the branch option in your pipeline.rb. Example:

```ruby
stage "Source" do
  github(
    source: "user/repo",
    branch: "master",
    auth_token: ssm("/github/user/token")
  )
end
```

When we deploy to create the pipelines, we can explicitly specify the branch to use. The cli option overrides the branch specified in `pipeline.rb`. Examples:

    pipe deploy demo-master -b master
    pipe deploy demo-qa -b qa

This creates 2 pipelines. The demo-master pipeline will use the master branch, and the demo-qa pipeline will use the qa branch.

To start the pipelines:

    pipe start demo-master
    pipe start demo-qa

{% include prev_next.md %}