require "yaml"

module Codepipe
  class Role
    include Codepipe::Dsl::Role
    include Evaluate

    def initialize(options={})
      @options = options
      @role_path = options[:role_path] || get_role_path
      @properties = default_properties
      @iam_policy = {}
    end

    def run
      evaluate(@role_path) if File.exist?(@role_path)
      @properties[:policies] = [{
        policy_name: "CodePipelineAccess",
        policy_document: {
          version: "2012-10-17",
          statement: derived_iam_statements
        }
      }]

      @properties[:managed_policy_arns] = @managed_policy_arns if @managed_policy_arns && !@managed_policy_arns.empty?

      resource = {
        logical_id => {
          type: "AWS::IAM::Role",
          properties: @properties
        }
      }
      CfnCamelizer.transform(resource)
    end

    def logical_id
      "IamRole"
    end

  private
    def get_role_path
      lookup_codepipeline_file("role.rb")
    end

    def default_properties
      {
        assume_role_policy_document: {
          statement: [{
            action: ["sts:AssumeRole"],
            effect: "Allow",
            principal: {
              service: principal_services
            }
          }],
          version: "2012-10-17"
        },
        path: "/"
      }
    end

    def principal_services
      ["codepipeline.amazonaws.com"]
    end

    def derived_iam_statements
      @iam_statements || default_iam_statements
    end

    def default_iam_statements
      [{
        effect: "Allow",
        action: "*",
        resource: "*"
      }]

      # [{
      #   action: ["iam:PassRole"],
      #   resource: "*",
      #   effect: "Allow",
      #   condition: {
      #     string_equals_if_exists: {
      #       "iam:PassedToService": [
      #         "codebuild.amazonaws.com",
      #         "cloudformation.amazonaws.com",
      #         "elasticbeanstalk.amazonaws.com",
      #         "ec2.amazonaws.com",
      #         "ecs-tasks.amazonaws.com"
      #       ]
      #     }
      #   }
      # },{
      #   action: [
      #     "logs:CreateLogGroup",
      #     "logs:CreateLogStream",
      #     "logs:PutLogEvents",
      #     "ssm:DescribeDocumentParameters",
      #     "ssm:DescribeParameters",
      #     "ssm:GetParameter*",
      #   ],
      #   effect: "Allow",
      #   resource: "*"
      # }]
    end
  end
end
