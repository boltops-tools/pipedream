# Codepipeline

![Build Status](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiM3hGMlViMUtRRS9maitXVnhPNUp2ZFE3eUkzV0doNG5OR0lRRGtNOVBiWDVsb0tjY2dTVnhHamJOSzZRYU5aaW9FOS9peEUwVHBVUzk3cXVjd2FqcHFNPSIsIml2UGFyYW1ldGVyU3BlYyI6InNDdzUzVmRCd0FHSjBrTnQiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)
[![Gem Version](https://badge.fury.io/rb/codepipeline.png)](http://badge.fury.io/rb/codepipeline)

The codepipeline tool provides a DSL to create a CodePipeline project with some reasonable defaults.

The codebuild tool installs `codepipline` and `pipe` executables. Both of them do the same thing, `pipe` is just shorter to type.

The documentation site is at: [codepipeline.org](https://codepipeline.org/)

## Quick Start

    pipe init
    pipe deploy
    pipe start
    pipe delete

The CLI tool also detects and tasks in the current folder's Rakefile and delegate to those tasks.

## Init and Structure

## DSL

.codepipeline/pipeline.rb:

```ruby
stage "Source" do
  github(
    source: "tongueroo/demo-ufo",
    auth_token: ssm("/github/user/token")
  )
end
stage "DeployStacks" do
  codebuild "demo1"           # action declaration
  codebuild "demo2", "demo3"  # will run in parallel
  codebuild "demo4"           # action declaration
end
```

More [DSL docs](https://codepipeline.org/docs/dsl/)

## Installation

Add this line to your application's Gemfile:

    gem "codepipeline"

And then execute:

    bundle

Or install it yourself as:

    gem install codepipeline

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
