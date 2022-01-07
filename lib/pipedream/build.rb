module Pipedream
  class Build
    def initialize(options)
      @options = options
    end

    def run
      options = @options
      Pipeline.new(options).run
    end
  end
end