require "thor"

# Override thor's long_desc identation behavior
# https://github.com/erikhuda/thor/issues/398
class Thor
  module Shell
    class Basic
      def print_wrapped(message, options = {})
        message = "\n#{message}" unless message[0] == "\n"
        stdout.puts message
      end
    end
  end
end

module Pipedream
  class Command < Thor
    class << self
      def dispatch(m, args, options, config)
        check_project!(args)

        # Allow calling for help via:
        #   codepipe command help
        #   codepipe command -h
        #   codepipe command --help
        #   codepipe command -D
        #
        # as well thor's normal way:
        #
        #   codepipe help command
        help_flags = Thor::HELP_MAPPINGS + ["help"]
        if args.length > 1 && !(args & help_flags).empty?
          args -= help_flags
          args.insert(-2, "help")
        end

        #   codepipe version
        #   codepipe --version
        #   codepipe -v
        version_flags = ["--version", "-v"]
        if args.length == 1 && !(args & version_flags).empty?
          args = ["version"]
        end

        super
      end

      def help_flags
        Thor::HELP_MAPPINGS + ["help"]
      end
      private :help_flags

      def subcommand?
        !!caller.detect { |l| l.include?('in subcommand') }
      end

      def check_project!(args)
        command_name = args.first
        return if subcommand?
        return if command_name.nil?
        return if help_flags.include?(args.last) # IE: -h help
        return if %w[-h -v --version central init start version].include?(command_name)
        return if File.exist?("#{Pipedream.root}/.pipedream")

        logger.error "ERROR: It doesnt look like this project has pipedream set up.".color(:red)
        logger.error "Are you sure you are in a project with .pipedream files?".color(:red)
        ENV['PIPE_TEST'] ? raise : exit(1)
      end

      # Override command_help to include the description at the top of the
      # long_description.
      def command_help(shell, command_name)
        meth = normalize_command_name(command_name)
        command = all_commands[meth]
        alter_command_description(command)
        super
      end

      def alter_command_description(command)
        return unless command

        # Add description to beginning of long_description
        long_desc = if command.long_description
            "#{command.description}\n\n#{command.long_description}"
          else
            command.description
          end

        # add reference url to end of the long_description
        unless website.empty?
          full_command = [command.ancestor_name, command.name].compact.join('-')
          url = "#{website}/reference/codepipe-#{full_command}"
          long_desc += "\n\nHelp also available at: #{url}"
        end

        command.long_description = long_desc
      end
      private :alter_command_description

      # meant to be overriden
      def website
        ""
      end
    end
  end
end
