module Pipedream
  class CLI < Command
    include Help

    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean

    desc "init", "Initialize project with .codepipline files"
    long_desc Help.text(:init)
    Init.cli_options.each do |args|
      option(*args)
    end
    register(Init, "init", "init", "Set up initial .codepipline files.")

    common_options = Proc.new do
      option :stack_name, desc: "Override the generated stack name. If you use this you must always specify it"
      option :wait, type: :boolean, default: true, desc: "Wait for operation to complete"
    end
    branch_option = Proc.new do
      option :branch, aliases: "b", desc: "git branch" # important to default to nil
    end
    yes_option = Proc.new do
      option :yes, aliases: "y", desc: "Bypass are you sure prompt"
    end

    desc "build PIPELINE_NAME", "Build CloudFormation Template"
    long_desc Help.text(:build)
    common_options.call
    branch_option.call
    def build(pipeline_name=nil)
      Pipedream::Builder.new(options.merge(pipeline_name: pipeline_name)).template
    end

    desc "up PIPELINE_NAME", "Deploy pipeline stack"
    long_desc Help.text(:up)
    option :branch, aliases: "b", desc: "git branch" # important to default to nil
    common_options.call
    branch_option.call
    yes_option.call
    def up(pipeline_name=nil)
      Pipedream::Cfn::Deploy.new(options.merge(pipeline_name: pipeline_name)).run
    end

    desc "start", "Start Pipeline"
    long_desc Help.text(:start)
    option :branch, aliases: "b", desc: "git branch" # important to default to nil
    common_options.call
    branch_option.call
    def start(pipeline_name=nil)
      Start.new(options.merge(pipeline_name: pipeline_name)).run
    end

    desc "down", "Delete CloudFormation stack with Pipeline"
    long_desc Help.text(:down)
    common_options.call
    yes_option
    def down(pipeline_name=nil)
      Down.new(options.merge(pipeline_name: pipeline_name)).run
    end

    desc "completion *PARAMS", "Prints words for auto-completion."
    long_desc Help.text("completion")
    def completion(*params)
      Completer.new(CLI, *params).run
    end

    desc "completion_script", "Generates a script that can be eval to setup auto-completion."
    long_desc Help.text("completion_script")
    def completion_script
      Completer::Script.generate
    end

    desc "version", "prints version"
    def version
      puts VERSION
    end
  end
end
