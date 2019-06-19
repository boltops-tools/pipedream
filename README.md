# Codepipeline

[![Gem Version](https://badge.fury.io/rb/codepipeline.png)](http://badge.fury.io/rb/codepipeline)

The codepipeline tool provides a DSL to create a CodePipeline project with some reasonable defaults.

The codebuild tool installs `codepipline` and `pipe` executables. Both of them do the same thing, `pipe` is just shorter to type.

## Quick Start

    pipe init
    pipe deploy
    pipe start

The CLI tool also detects and tasks in the current folder's Rakefile and delegate to those tasks.

## Init and Structure

## DSL


## Installation

Add this line to your application's Gemfile:

    gem "codepipe"

And then execute:

    bundle

Or install it yourself as:

    gem install codepipe

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
