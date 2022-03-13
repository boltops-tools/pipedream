require "aws-sdk-cloudformation"
require "aws-sdk-codepipeline"
require "aws-sdk-s3"

require "aws_mfa_secure/ext/aws" # add MFA support

module Pipedream
  module AwsServices
    extend Memoist
    include Concerns

    def codepipeline
      Aws::CodePipeline::Client.new(aws_options)
    end
    memoize :codepipeline

    def cfn
      Aws::CloudFormation::Client.new(aws_options)
    end
    memoize :cfn

    def s3
      Aws::S3::Client.new(aws_options)
    end
    memoize :s3

    # Override the AWS retry settings with AWS clients.
    #
    # The aws-sdk-core has exponential backup with this formula:
    #
    #   2 ** c.retries * c.config.retry_base_delay
    #
    # Source:
    #   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-core/lib/aws-sdk-core/plugins/retry_errors.rb
    #
    # So the max delay will be 2 ** 7 * 0.6 = 76.8s
    #
    # Only scoping this to deploy because dont want to affect people's application that use the aws sdk.
    #
    # There is also additional rate backoff logic elsewhere, since this is only scoped to deploys.
    #
    # Useful links:
    #   https://github.com/aws/aws-sdk-ruby/blob/master/gems/aws-sdk-core/lib/aws-sdk-core/plugins/retry_errors.rb
    #   https://docs.aws.amazon.com/apigateway/latest/developerguide/limits.html
    #
    def aws_options
      options = {
        retry_limit: 7, # default: 3
        retry_base_delay: 0.6, # default: 0.3
      }
      options.merge!(
        log_level: :debug,
        logger: Logger.new($stdout),
      ) if ENV['UFO_DEBUG_AWS_SDK']
      options
    end
  end
end