# Pipeline DSL

.codepipeline/pipeline.rb:

```ruby
stage "Source" do
  github(
    source: "tongueroo/demo-cb",
    auth_token: ssm("/github/user/token")
  )
end
stage "DeployStacks" do
  codebuild "demo1"           # action declaration
  codebuild "demo2", "demo3"  # will run in parallel. run_order=2
  codebuild "demo4"           # action declaration
end
```

## Under the Hood

The convenience methods are shorter and cleaner. However, you have access to a "Full" DSL if needed. The Full DSL are merely the properties of the [AWS::CodePipeline::Pipeline](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codepipeline-pipeline.html).  Here's an example.

.codepipeline/pipeline.rb:

```ruby
stage "Source" do
  action(
    name: "Source",
    action_type_id: {
      category: "Source",
      owner: "ThirdParty",
      provider: "GitHub",
      version: "1",
    },
    run_order: 1,
    configuration: {
      branch: "master",
      o_auth_token: ssm("/github/user/token"),
      owner: "tongueroo",
      poll_for_source_changes: "false",
      repo: "demo-cb"
    },
    output_artifacts: [name: "SourceArtifact"]
  )
end

stage "Deploy Stacks" do
  # serial
  action(
    name: "Build1",
    action_type_id: {
      category: "Build",
      owner: "AWS",
      provider: "CodeBuild",
      version: "1",
    },
    run_order: 2,
    configuration: { project_name: "demo1" },
    input_artifacts: [name: "SourceArtifact"],
  )
  action(
    name: "Build2",
    action_type_id: {
      category: "Build",
      owner: "AWS",
      provider: "CodeBuild",
      version: "1",
    },
    run_order: 2,
    configuration: { project_name: "demo2" },
    input_artifacts: [name: "SourceArtifact"],
  )
end
```

