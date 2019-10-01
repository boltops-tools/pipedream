# Pipedreamline

![Build Status](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiM3hGMlViMUtRRS9maitXVnhPNUp2ZFE3eUkzV0doNG5OR0lRRGtNOVBiWDVsb0tjY2dTVnhHamJOSzZRYU5aaW9FOS9peEUwVHBVUzk3cXVjd2FqcHFNPSIsIml2UGFyYW1ldGVyU3BlYyI6InNDdzUzVmRCd0FHSjBrTnQiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)
[![Gem Version](https://badge.fury.io/rb/pipedream.png)](http://badge.fury.io/rb/pipedream)

Pipe Dream provides a DSL to make it easy create a CodePipeline pipeline.

Pipe Dream installs `pipedream` and `pipe` executables. Both of them do the same thing, `pipe` is just shorter to type.

The documentation site is at: [pipedream.run](https://pipedream.run/)

## Quick Start

    pipe init
    pipe deploy
    pipe start
    pipe delete

## Init and Structure

First, run `pipe init` to generate a starter `.pipedream` folder structure.

    $ tree .pipedream
    .pipedream
    ├── pipeline.rb
    ├── schedule.rb
    ├── settings.yml
    └── sns.rb

File | Description
--- | ---
pipeline.rb | The CodePipeline pipeline written as a DSL.  This is required. Here are the [Pipeline DSL docs](https://pipedream.run/docs/dsl/pipeline/)
schedule.rb | A CloudWatch scheduled event written as a DSL. Here are the [schedule.rb docs](https://pipedream.run/docs/dsl/schedule/)
settings.yml | Settings to for pipedream.  Here are the [Settings docs](https://pipedream.run/docs/settings/)
sns.rb | An SNS topic associated with an [Approval action](https://pipedream.run/docs/dsl/pipeline/approve/) written as a DSL.  Here are the [SNS docs](https://pipedream.run/docs/dsl/sns/)

## DSL

.pipedream/pipeline.rb:

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

More [DSL docs](https://pipedream.run/docs/dsl/)

## Installation

Add this line to your application's Gemfile:

    gem "pipedream"

And then execute:

    bundle

Or install it yourself as:

    gem install pipedream

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
