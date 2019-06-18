$:.unshift(File.expand_path("../", __FILE__))
require "codepipe/version"
require "rainbow/ext/string"

require "codepipe/autoloader"
Codepipe::Autoloader.setup

module Codepipe
  class Error < StandardError; end
end
