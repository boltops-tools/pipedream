---
title: Naming Conventions
nav_order: 8
---

Pipe Dream follows a few naming conventions.

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

If the append_env is configured in the [Settings]({% link _docs/settings.md %}), then the `PIPE_ENV` is added to the pipeline name. For example: `demo-development` instead of `demo`.

## Pipeline and Stack Names

The CloudFormation stack name which creates the CodePipeline related resources is named the same as the pipeline name with `-pipe` appended to the stack name. Examples:

PIPE_ENV | PIPE_ENV_EXTRA | append_env | Pipeline Name | Stack Name
--- | --- | --- | --- | ---
development | (not set) | false | demo | demo-pipe
development | (not set) | true | demo-development | demo-development-pipe
production | (not set) | true | demo-production | demo-production-pipe
development | 2 | false | demo-2 | demo-2-pipe
development | (not set) | true | demo-development | demo-development-pipe |
development | 2 | true | demo-development | demo-development-2-pipe

{% include prev_next.md %}
