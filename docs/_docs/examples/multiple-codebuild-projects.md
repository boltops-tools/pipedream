---
title: Multiple CodeBuild Projects
nav_text: Multiple CodeBuild
categories: examples
nav_order: 20
---

In this example guide, we'll create a couple of test CodeBuild projects and quickly connect them up to a pipeline.

## CodeBuild Projects

We'll use the the [cody](https://cody.run/) tool to quickly get going.

You can use any project, even an empty folder. You just have to make sure it is pushed to GitHub and has a `buildspec.yml`.  If you need an example project, you can try this one: [tongueroo/demo-ufo](https://github.com/tongueroo/demo-ufo).

First, you can use `cody init` create some starter `.cody` files.

    gem install cody # installs cody command
    cody init # create starter .cody files including buildspec.yml
    git add .
    git commit -m 'add starter .cody files'
    git push

Then create the 4 CodeBuild projects for testing:

    for i in {1..4} ; do cody deploy demo$i --no-wait ; done

## CodePipeline

Let's define a pipeline now with the 4 CodeBuild test projects. First, use `pipe init` to create the starter `.pipedream` files. Update your `pipeline.rb` with the following:

.pipedream/pipeline.rb:

```ruby
stage "Source" do
  github(
    source: "tongueroo/demo-ufo", # replace with your repo
    auth_token: ssm("/github/user/token")
  )
end

stage "Build" do
  codebuild "demo1"
  codebuild "demo2", "demo3" # runs in parallel
  codebuild "demo4"
end
```

Deploy it with:

    pipe deploy

Last, start the pipeline execution:

    pipe start

That's it!  The pipeline will look like this:

![](/img/docs/multiple-codebuild-projects-pipeline.png)

{% include prev_next.md %}
