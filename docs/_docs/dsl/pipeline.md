---
title: Pipeline DSL
nav_text: Pipeline
categories: dsl
nav_order: 10
---

The pipeline DSL allows you to define the Stages and Actions within that Stage with only a few lines of code. In the [Quick Start]({% link quick-start.md %}), we define a very short pipeline to keep the introduction simple.  Here we'll show more of the DSL power.

```ruby
stage "Source" do
  github(
    source: "tongueroo/demo-test",
    auth_token: ssm("/github/user/token")
  )
end

stage "Build" do
  codebuild "demo1", "demo2"
  codebuild "demo3"
end

stage "Approve" do
  approve("Approve this deploy")
end

stage "Deploy" do
  codebuild "deploy"
end
```

This pipeline has 3 stages:

1. Downloads the source code from Gitub and uploads it to S3 as an output artifact.
2. Starts 3 codebuild projects with s3 upload from the previous step as an input artifact.
3. Waits for a manual approval stage.
4. Uses another codebuild project to kick off a deploy.

## Build Stage

Within the build stage, there are multiple actions. Some of them run in parallel and some in serial.

* The demo1 and demo2 codebuild projects run on the same `RunOrder=1`.  They run in parallel.
* The demo3 codebuild project run with `RunOrder=2`.  It starts after both demo1 and demo2 finishes.

The Pipeline DSL allows to you connect the stages together how you want them with very little code.

## Pipeline Specific DSL Docs

{% assign docs = site.docs | where: "categories","dsl-pipeline" %}
{% for doc in docs -%}
* [{{doc.nav_text}}]({{doc.url}})
{% endfor %}

{% include prev_next.md %}