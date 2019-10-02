require "aws-sdk-codepipeline"
require "aws-sdk-cloudformation"

module Pipedream
  module AwsServices
    include Helpers

    def codepipeline
      @codepipeline ||= Aws::CodePipeline::Client.new
    end

    def cfn
      @cfn ||= Aws::CloudFormation::Client.new
    end

    def s3
      @s3 ||= Aws::S3::Client.new
    end
  end
end