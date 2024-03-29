$:.unshift(File.expand_path("../", __FILE__))
require "pipedream/version"
require "rainbow/ext/string"
require "memoist"
require "active_support"
require "active_support/core_ext/hash"

require "pipedream/autoloader"
Pipedream::Autoloader.setup

gem_root = File.dirname(__dir__)
$:.unshift("#{gem_root}/vendor/aws_data/lib")
require "aws_data"
$:.unshift("#{gem_root}/vendor/cfn_camelizer/lib")
require "cfn_camelizer"
$:.unshift("#{gem_root}/vendor/cfn-status/lib")
require "cfn/status"

module Pipedream
  class Error < StandardError; end
  extend Core
end

Pipedream.set_aws_profile!
