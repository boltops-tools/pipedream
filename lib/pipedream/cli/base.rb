class Pipedream::CLI
  class Base
    extend Memoist
    include Pipedream::AwsServices
    include Pipedream::Utils::Logging
    include Pipedream::Utils::Pretty

    def initialize(options={})
      @options = options
      @pipeline_name = @options[:pipeline_name] || inferred_pipeline_name
      @stack_name = options[:stack_name] || inferred_stack_name(@pipeline_name)
      @full_pipeline_name = pipeline_name_convention(@pipeline_name)
    end
  end
end
