---
title: Create CodeBuild Project
nav_text: Create CodeBuild
categories: examples
nav_order: 19
---

It is common to use CodeBuild as a Stage Action in the pipeline. Here's are instructions to quickly create a CodeBuild project.

We'll use the [cody.run](https://cody.run) tool to help with this. Here are the commands.

    gem install cody # installs cody command
    cody init # generates starter .cody files including the buildspec.yml
    # edit and commit the .cody files
    git add .cody
    git commit -m 'add .cody files'
    git push
    cody deploy demo # creates a codebuild project

There's also an example where we quickly create 4 test codebuild projects here: [Multiple CodeBuild Projects](https://codepipeline.org/docs/examples/multiple-codebuild-projects/).

{% include prev_next.md %}
