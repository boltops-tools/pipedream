module Pipedream
  class CLI < Command
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

    desc "deploy PIPELINE_NAME", "Deploy pipeline."
    long_desc Help.text(:deploy)
    option :branch, aliases: "b", desc: "git branch" # important to default to nil
    common_options.call
    def deploy(pipeline_name=nil)
      Deploy.new(options.merge(pipeline_name: pipeline_name)).run
    end

    desc "start", "Start codebuild project."
    long_desc Help.text(:start)
    option :sure, desc: "Bypass are you sure prompt"
    option :branch, aliases: "b", desc: "git branch" # important to default to nil
    common_options.call
    def start(pipeline_name=nil)
      Start.new(options.merge(pipeline_name: pipeline_name)).run
    end

    desc "delete", "Delete codebuild project."
    long_desc Help.text(:delete)
    option :sure, desc: "Bypass are you sure prompt"
    common_options.call
    def delete(pipeline_name=nil)
      Delete.new(options.merge(pipeline_name: pipeline_name)).run
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
