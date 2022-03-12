$:.unshift(File.expand_path("../", __FILE__))
require "active_support"
require "active_support/core_ext/hash"
require "aws_data"
require "cfn-status"
require "cfn_camelizer"
require "dsl_evaluator"
require "memoist"
require "pipedream/version"
require "rainbow/ext/string"
require "yaml"

require "pipedream/autoloader"
Pipedream::Autoloader.setup

module Pipedream
  class Error < StandardError; end
  extend Core
end
