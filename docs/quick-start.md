---
title: Quick Start
nav_order: 1
---

In a hurry? No problem!  Here's a quick start to get going.

## Summary

    gem install pipedream
    cd <your-project>
    pipe init # generates starter .pipedream files
    # edit .pipedream/pipeline.rb
    pipe deploy # create the CodePipeline pipeline via CloudFormation
    pipe start  # start a CodePipeline pipeline execution

## What Happened?

Here are a little more details on what the summarized commands do. First, we install the pipedream tool.

    gem install pipedream

Change into your project directory.

    cd <your-project>

If you need a demo project, you can try this demo project: [tongueroo/demo-ufo](git clone https://github.com/tongueroo/demo-ufo).

    git clone https://github.com/tongueroo/demo-ufo demo
    cd demo

Create the starter .pipedream files in the project.

    pipe init # generates starter .pipedream files

An important generated file is `.pipedream/pipeline.rb`. The starter file defines the pipeline via an [CodePipeline DSL]({% link _docs/dsl.md %}). It looks something like this:

```ruby
stage "Source" do
  github(
    source: "user/repo", # replace with your repo
    auth_token: ssm("/github/user/token") # replace with your token
  )
end

stage "Build" do
  codebuild "demo"
end
```

The pipeline definition is much shorter than typical CloudFormation code. In this short pipeline, there are 2 stages:

1. Downloads the source code from Gitub and uploads it to S3 as an output artifact.
2. Starts some codebuild project with the code that was previously uploaded to s3 as the input artifact.

Note, you need to have a codebuild project already created as a prerequisite. The example instructions for that are here: [Create CodeBuild Project]({% link _docs/examples/codebuild-project.md %}).

You can then deploy or create the pipeline with a single command:

    pipe deploy

This deploys a CloudFormation stack that creates a CodePipeline pipeline and IAM role.  The IAM role permissions is defined in `.pipedream/role.rb` via the [IAM Role DSL]({% link _docs/dsl/role.md %}).

Once the stack is complete. You can start the CodePipeline pipeline via the CLI or the CodePipeline console.  Here is the CLI command:

    pipe start

Here's what CodePipeline pipeline output looks like:

![](/img/docs/codepipeline-output.png)

{% include prev_next.md %}
