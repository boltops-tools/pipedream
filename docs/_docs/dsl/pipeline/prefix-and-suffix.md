---
title: Prefix and Suffix Option
nav_text: Prefix and Suffix
categories: dsl-pipeline
nav_order: 14
---

Somewhat interesting options are the `codebuild_prefix` and `codebuild_suffix` option. These options affect the `codebuild` method and allow you to remove some duplication in the pipeline declaration.

## Example

An example helps explain:

Let's say you have 3 codebuild projects that deploy different tiers of the same codebase:

* demo-web-deploy
* demo-clock-deploy
* demo-worker-deploy

The setup makes use of 3 codebuild projects, so we have control over deploying each tier separately if desired. Typically, to define this with `pipeline.rb`, it could look something like this.

```ruby
# Example 1
stage "Deploy" do
  codebuild "demo-web-deploy", "demo-clock-deploy", "demo-worker-deploy"
end
```

The resulting inferred Action names in the Stage would be a little lengthy and look like this: `DemoWebDeploy`, `DemoClockDeploy`, `DemoWorkerDeploy`. If you wanted to use shorter names like `Web`, `Clock`, and `Worker`, you'd need to use the [Simpified Hash Form]({% link _docs/dsl/pipeline/codebuild.md %}).

```ruby
# Example 2
stage "Deploy" do
  codebuild(
    {name: "Web", project_name: "demo-web-deploy"},
    {name: "Clock", project_name: "demo-clock-deploy"},
    {name: "Worker", project_name: "demo-worker-deploy"}
end
```

## Prefix and Suffix Option

If you use the `codebuild_prefix` and `codebuild_suffix`, it'll remove the need to use the Simplified Hash Form.

```ruby
# Example 3
codebuild_prefix "demo-"
codebuild_suffix "-deploy"

stage "Deploy" do
  codebuild "web", "clock", "worker"
end
```

So Example 2 and Example 3 are equivalent.

{% include prev_next.md %}
