<div align="center">
  <a href="http://pipedream.run"><img src="https://uc36e028c6cb752b665158d3d40f.previews.dropboxusercontent.com/p/thumb/AAn9XKH3Lq6cl3bQeuQHwBozQDPXpdRkNAbftzPwXN-ecs_3BjSc5ZRu9is4fTs9Tx0IwAcjY3gerzPXL0iWGiR0bMD3RZcfyGHm-p8GYP8TZ6O0cU56wjm8badwkVXX9zEvquPBmdwolzd1qnSZBeDxSirye-Ie1Hrc73_JeF8OqsM37Ed8mClMRDJscH05EwbaUBdZc8csNThy2_Y-kNB3eFYhoa8jlPxaBEeYcE1B3azr8k2IRNw2UMp70dcLHc2LT-w_gJaEHKIsAU3lGBrnZfcPpDnhhtq1CDv2HsW2jMTSQ8Za0M-aURRZP3Ge_zetXBkApajaL4tLSo7AwTcnFb3IU9rxVxnihdK0GuwcC-qMkpmvR605ZmJ3YS_P-bVugcd0B9ZJ0mYzCGaRIskjdciFzVibwsbIeo8mYyLBGWdgQZZOyAYUxYer2lxCL-TDW6QhA2EL3M2qCgvjwzQqE3iisYMEkdFz0iemxz_ToKujsakyKzTXAXoO4wYo3Lc/p.png?fv_content=true&size_mode=5" /></a>
</div>

# Pipe Dream

![Build Status](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiWk1FM0dldzE5MUM5R3VqVGxxTmRFb1JGNnkxQjJpTDYvajYrQk91YzErNjdNc1VYVElHM3V5ZEJXcStyMmZVc210WG8vUURSV2JST0ZpSWc5Y0pYR3k0PSIsIml2UGFyYW1ldGVyU3BlYyI6IldvYXhLMU8yS2pQdVRKbEoiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)
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
    └── schedule.rb

File | Description
--- | ---
pipeline.rb | The CodePipeline pipeline written as a DSL.  This is required. Here are the [Pipeline DSL docs](https://pipedream.run/docs/dsl/pipeline/)
schedule.rb | A CloudWatch scheduled event written as a DSL. Here are the [schedule.rb docs](https://pipedream.run/docs/dsl/schedule/)

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
