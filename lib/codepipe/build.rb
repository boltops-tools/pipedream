module Codepipe
  class Build
    def initialize(options)
      @options = options
    end

    def run
      puts "build"
      options = @options
      Pipeline.new(options).run
    end
  end
end