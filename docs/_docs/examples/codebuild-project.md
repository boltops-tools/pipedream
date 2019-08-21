---
title: Create CodeBuild Project
nav_text: Create CodeBuild
categories: examples
nav_order: 19
---

It is common to use codebuild as a Stage Action in the pipeline. Here's are instructions to quickly create a codebuild project.

We'll use the [codebuild.cloud](https://codebuild.cloud) tool to help with this. Here are the commands.

    gem install codebuild # installs cb command
    cb init # generates starter .codebuild files including the buildspec.yml
    # commit and yours the .codebuild files
    git add .codebuild
    git commit -m 'add .codebuild files'
    git push
    cb deploy demo # creates a codebuild project

There's also an example where we quickly create 4 test codebuild projects here: [Multiple CodeBuild Projects](https://codepipeline.org/docs/examples/multiple-codebuild-projects/).

{% include prev_next.md %}