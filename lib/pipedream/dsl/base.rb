module Pipedream::Dsl
  class Base < Pipedream::CLI::Base
    include DslEvaluator

    def initialize(options={})
      super
      @properties = default_properties # interface method
    end

    def lookup_pipedream_file(name)
      [".pipedream", @options[:type], name].compact.join("/")
    end
  end
end
