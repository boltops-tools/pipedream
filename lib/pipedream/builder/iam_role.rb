class Pipedream::Builder
  class IamRole < Pipedream::Dsl::Base
    include Pipedream::Dsl::IamRole

    def build
      evaluate_file(iam_role_path) if File.exist?(iam_role_path)
      @properties[:Policies] = [{
        PolicyName: "CodePipelineAccess",
        PolicyDocument: {
          Version: "2012-10-17",
          Statement: derived_iam_statements,
        }
      }]

      @properties[:ManagedPolicyArns] = @managed_policy_arns if @managed_policy_arns && !@managed_policy_arns.empty?

      resource = {
        logical_id => {
          Type: "AWS::IAM::Role",
          Properties: @properties
        }
      }
      auto_camelize(resource)
    end

    def logical_id
      "IamRole"
    end

  private
    def default_properties
      {
        AssumeRolePolicyDocument: {
          Statement: [{
            Action: ["sts:AssumeRole"],
            Effect: "Allow",
            Principal: {
              Service: principal_services
            }
          }],
          Version: "2012-10-17"
        },
        Path: "/"
      }
    end

    def principal_services
      ["codepipeline.amazonaws.com"]
    end

    def derived_iam_statements
      @iam_statements || default_iam_statements
    end

    # Based on the one created by CodePipeline Console
    def default_iam_statements
      text =<<~EOL
        ---
        - Action:
          - iam:PassRole
          Resource: "*"
          Effect: Allow
          Condition:
            StringEqualsIfExists:
              Iam:passedToService:
              - cloudformation.amazonaws.com
              - elasticbeanstalk.amazonaws.com
              - ec2.amazonaws.com
              - ecs-tasks.amazonaws.com
        - Action:
          - codecommit:CancelUploadArchive
          - codecommit:GetBranch
          - codecommit:GetCommit
          - codecommit:GetUploadArchiveStatus
          - codecommit:UploadArchive
          Resource: "*"
          Effect: Allow
        - Action:
          - codedeploy:CreateDeployment
          - codedeploy:GetApplication
          - codedeploy:GetApplicationRevision
          - codedeploy:GetDeployment
          - codedeploy:GetDeploymentConfig
          - codedeploy:RegisterApplicationRevision
          Resource: "*"
          Effect: Allow
        - Action:
          - elasticbeanstalk:*
          - ec2:*
          - elasticloadbalancing:*
          - autoscaling:*
          - cloudwatch:*
          - s3:*
          - sns:*
          - cloudformation:*
          - rds:*
          - sqs:*
          - ecs:*
          Resource: "*"
          Effect: Allow
        - Action:
          - lambda:InvokeFunction
          - lambda:ListFunctions
          Resource: "*"
          Effect: Allow
        - Action:
          - opsworks:CreateDeployment
          - opsworks:DescribeApps
          - opsworks:DescribeCommands
          - opsworks:DescribeDeployments
          - opsworks:DescribeInstances
          - opsworks:DescribeStacks
          - opsworks:UpdateApp
          - opsworks:UpdateStack
          Resource: "*"
          Effect: Allow
        - Action:
          - cloudformation:CreateStack
          - cloudformation:DeleteStack
          - cloudformation:DescribeStacks
          - cloudformation:UpdateStack
          - cloudformation:CreateChangeSet
          - cloudformation:DeleteChangeSet
          - cloudformation:DescribeChangeSet
          - cloudformation:ExecuteChangeSet
          - cloudformation:SetStackPolicy
          - cloudformation:ValidateTemplate
          Resource: "*"
          Effect: Allow
        - Action:
          - codebuild:BatchGetBuilds
          - codebuild:StartBuild
          Resource: "*"
          Effect: Allow
        - Action:
          - devicefarm:ListProjects
          - devicefarm:ListDevicePools
          - devicefarm:GetRun
          - devicefarm:GetUpload
          - devicefarm:CreateUpload
          - devicefarm:ScheduleRun
          Resource: "*"
          Effect: Allow
        - Action:
          - servicecatalog:ListProvisioningArtifacts
          - servicecatalog:CreateProvisioningArtifact
          - servicecatalog:DescribeProvisioningArtifact
          - servicecatalog:DeleteProvisioningArtifact
          - servicecatalog:UpdateProduct
          Resource: "*"
          Effect: Allow
        - Action:
          - cloudformation:ValidateTemplate
          Resource: "*"
          Effect: Allow
        - Action:
          - ecr:DescribeImages
          Resource: "*"
          Effect: Allow
      EOL
      YAML.load(text)
    end

  private
    def iam_role_path
      lookup_pipedream_file("iam_role.rb")
    end
  end
end
