---
title: Action General Method
nav_text: Action
categories: dsl-pipeline
nav_order: 11
---

The `action` method is a general way to add Actions to your pipeline Stages. Generally, it is recommended to use the helper methods like [codebuild]({% link _docs/dsl/pipeline/codebuild.md %}) and [approve]({% link _docs/dsl/approve.md %}) when possible as it makes the code concise.  Here's an example of a pipeline using the general `action` method.

```ruby
stage "Build" do
  action(
    name: "action1",
    action_type_id: {
      category: "Build",
      owner: "AWS",
      provider: "CodeBuild",
      version: "1",
    },
    run_order: 1,
    configuration: { project_name: 'demo1' },
    # output_artifacts: [name: "BuildArtifact#{name}"], # optional
    input_artifacts: [name: "SourceArtifact"], # default
  )
end
```

{% include prev_next.md %}