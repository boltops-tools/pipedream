$:.unshift(File.expand_path("../", __FILE__))
require "codepipe/version"
require "rainbow/ext/string"
require "memoist"
require "active_support/core_ext/hash"

require "codepipe/autoloader"
Codepipe::Autoloader.setup

gem_root = File.dirname(__dir__)
$:.unshift("#{gem_root}/vendor/aws_data/lib")
require "aws_data"
$:.unshift("#{gem_root}/vendor/cfn_camelizer/lib")
require "cfn_camelizer"
$:.unshift("#{gem_root}/vendor/cfn-status/lib")
require "cfn/status"

module Codepipe
  class Error < StandardError; end
  extend Core
end

Codepipe.set_aws_profile!
