---
title: Action General Method
nav_text: Action
categories: dsl-pipeline
nav_order: 11
---

The `action` method is a generalized way to add Actions to pipeline Stages. Generally, it is recommended to use the helper methods like [codebuild]({% link _docs/dsl/pipeline/codebuild.md %}) and [approve]({% link _docs/dsl/pipeline/approve.md %}) when possible to keep code concise.  Here's an example of a pipeline using the generalized `action` method.

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
    input_artifacts: [name: "SourceArtifact"], # SourceArtifact is the default primary source
  )
end
```

{% include prev_next.md %}
