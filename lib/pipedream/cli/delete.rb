class Pipedream::CLI
  class Delete < Base
    def run
      message = "Deleted #{@stack_name} stack."
      if @options[:noop]
        puts "NOOP #{message}"
      else
        are_you_sure?

        if stack_exists?(@stack_name)
          cfn.delete_stack(stack_name: @stack_name)
          puts message
        else
          puts "#{@stack_name.inspect} stack does not exist".color(:red)
        end
      end
    end

  private
    def are_you_sure?
      message = "Will delete stack #{@stack_name.color(:green)}"
      if @options[:yes]
        logger.info message
      else
        sure?(message)
      end
    end
  end
end
