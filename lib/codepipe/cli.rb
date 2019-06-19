module Codepipe
  class CLI < Command
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean

    common_options = Proc.new do
      option :stack_name, desc: "Override the generated stack name. If you use this you must always specify it"
      option :wait, type: :boolean, default: true, desc: "Wait for operation to complete"
    end

    desc "deploy PIPELINE_NAME", "Deploy pipeline."
    long_desc Help.text(:deploy)
    common_options.call
    def deploy(pipeline_name=nil)
      Deploy.new(options.merge(pipeline_name: pipeline_name)).run
    end

    desc "delete", "Delete codebuild project."
    long_desc Help.text(:delete)
    option :sure, desc: "Bypass are you sure prompt"
    common_options.call
    def delete(project_name=nil)
      Delete.new(options.merge(project_name: project_name)).run
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
