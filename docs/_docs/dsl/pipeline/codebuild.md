---
title: Codebuild Project
nav_text: Codebuild
categories: dsl-pipeline
nav_order: 12
---

The `codebuild` method is one of the most useful methods in the `pipeline.rb` DSL arsenal.  With it, you can add codebuild projects to your pipeline and sequence them quickly.  Let's start with the simplest form.

## String Form

With the String form, the String sets both the name of the CodePipeline Action and CodeBuild Project.

```ruby
stage "Deploy" do
  codebuild "demo1"
  codebuild "demo2", "demo3" # runs in parallel
  codebuild "demo4"
end
```

With just a few lines of code, we have define the pipeline to run the `demo1` codebuild project first.  Then run `demo2` and `demo3` in parallel. Last, run `demo4`.

## Simplified Hash Form

With the Simplified Hash form, we have more control over the CodePipeline Action and CodeBuild Project names.

```ruby
stage "Deploy" do
  codebuild(name: "action1", project_name: "demo1")
  codebuild({name: "action2", project_name: "demo2"}, {name: "action3", project_name: "demo3"}) # runs in parallel
  codebuild(name: "action4", project_name: "demo4")
end
```

In this form, we can explicitly set what the Action Name shows up as in the CodePipeline. We can also set the CodeBuild project name explicitly.

## Full Hash Form

With the Full Hash Form, we have full control of the Action properties.  To keep this example concise, we'll declare only one codebuild Action.

```ruby
stage "Build" do
  codebuild(
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

The various forms all use ultimately all merge the properties down to the Full Hash Form.  Generally, it is recommended you start with the simplest form and use the more complex forms when required.

{% include prev_next.md %}