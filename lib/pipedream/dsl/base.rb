module Pipedream::Dsl
  class Base < Pipedream::CLI::Base
    include Evaluate

    def initialize(options={})
      super
      @properties = default_properties # interface method
    end
  end
end
