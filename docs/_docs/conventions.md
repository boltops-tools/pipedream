---
title: Naming Conventions
nav_order: 7
---

The codepipeline tool follows a few naming conventions.

## Pipeline Name

It will set the pipeline name by inferring the name of the parent folder.  For example, if the parent folder is `demo`.

    cd demo
    pipe deploy

The pipeline is named `demo`. You can override this easily by providing a pipeline name.

    pipe deploy my-pipeline # explicitly use my-pipeline as pipeline name

The pipeline is named `my-pipeline`

## PIPE_ENV_EXTRA

The `PIPE_ENV_EXTRA` also affects the name of the pipeline.  It gets appended at the end of the pipeline name.

    PIPE_ENV_EXTRA=2 pipe deploy my-pipeline

The pipeline is named `my-pipeline-2`.

## Settings append_env option

If the append_env is configured in the [Settings]({% link _docs/settings.md %}).

## Stack Name

The CloudFormation stack name which creates the CodePipeline related resources is named the same as the pipeline name with `-cb` appended to the stack name. Examples:

Pipeline Name | Stack Name
--- | ---
demo | demo-cb
demo-unit | demo-unit-cb
demo-web-unit | demo-web-unit-cb

{% include prev_next.md %}
