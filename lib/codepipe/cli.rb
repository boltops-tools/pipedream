module Codepipe
  class CLI < Command
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean

    desc "build NAME", "Build pipeline NAME."
    long_desc Help.text(:build)
    def build(name=nil)
      Build.new(options.merge(name: name)).run
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
