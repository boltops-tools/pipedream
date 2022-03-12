module Pipedream::Dsl
  class Base < Pipedream::CLI::Base
    def initialize(options={})
      super
      @properties = default_properties # interface method
    end
  end
end
