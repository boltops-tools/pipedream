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

    # In v1.0.0 defaults to not auto-camelize
    def auto_camelize(data)
      if Pipedream.config.auto_camelize
        CfnCamelizer.transform(data)
      else
        data.deep_stringify_keys!
        data
      end
    end
  end
end
