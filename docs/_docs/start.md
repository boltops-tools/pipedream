---
title: Start
nav_order: 6
---

You can start a pipeline with the `pipe start` command. Here's an example:

    $ pipe start
    Pipeline started: demo
    Please check the CodePipeline console for the status.
    CodePipeline Console: https://us-west-2.console.aws.amazon.com/codesuite/codepipeline/pipelines/demo/view
    Pipeline cli: aws codepipeline get-pipeline-execution --pipeline-execution-id 02579d64-9271-4edc-aa45-bc9629d732bb --pipeline-name demo
    $

## Specifying Code Branch

If you would like start a build using a specific code branch you can use the `--branch` or `-b` option.  Example:

    pipe start -b feature-branch

Note: When you specify a branch the codepipeline tool actually first updates the pipeline before starting the pipeline execution. This is done because CodePipeline does not natively support specifying the branch. It is discussed more here: [Using Different Branches]({% link _docs/examples/different-branches.md %}).

## AWS CLI Equivalent

The `pipe start` command is a simple wrapper to the AWS API with the ruby sdk. You can also start pipelines with the `aws codepipeline` cli.  Here's the equivalent CLI command:

    aws codepipeline start-pipeline-execution --name demo

Note: There is no native branch option with the `aws codepipeline` cli.

## CLI Reference

Also, for help info you can check the [pipe start]({% link _reference/pipe-start.md %}) CLI reference.

{% include prev_next.md %}