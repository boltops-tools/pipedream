---
title: Quick Start
nav_order: 1
---

In a hurry? No problem!  Here's a quick start to get going.

## Summary

    gem install codepipeline
    cd <your-project>
    pipe init # generates starter .codepipeline files
    # edit .codepipeline/pipeline.rb
    pipe deploy # create the CodePipeline pipeline via CloudFormation
    pipe start  # start a CodePipeline pipeline execution

## What Happened?

Here are a little more details on what the summarized commands do. First, we install the codepipeline tool.

    gem install codepipeline

Change into your project directory.

    cd <your-project>

If you need a demo project, you can try this demo project: [tongueroo/demo-ufo](git clone https://github.com/tongueroo/demo-ufo).

    git clone https://github.com/tongueroo/demo-ufo demo
    cd demo

Create the starter .codepipeline files in the project.

    pipe init # generates starter .codepipeline files

An important generated file `.codepipeline/pipeline.rb`. The starter file looks something like this:

```ruby
stage "Source" do
  github(
    source: "tongueroo/demo-test",
    auth_token: ssm("/github/user/token")
  )
end

stage "Build" do
  codebuild "demo"
end
```

This is a short pipeline that has 2 stages:

1. downloads the source code from Gitub and uploads it to S3 as a output artifact
2. starts some codebuild project with the code that was previously uploaded to s3 as the output artifact

Note: you have to create the codebuild projects as a prequisite.  The [codebuild.cloud](https://codebuild.cloud) tool helps with this.

To define a pipeline, it much shorter than typical CloudFormation code. You can then create the pipeline with a single command:

    pipe deploy

This deploys a CloudFormation stack that creates a CodePipeline pipeline and IAM role.  The IAM role permissions is defined in `.codepipeline/role.rb` via the [IAM Role DSL]({% link _docs/dsl/role.md %}).

Once the stack is complete. You can start the CodePipeline pipeline via the CLI or the CodePipeline console.  Here is the CLI command:

    pipe start

Here's what CodePipeline pipeline output looks like:

![](/img/docs/codepipeline-output.png)

{% include prev_next.md %}