class Pipedream::Builder
  class IamRole < Pipedream::Dsl::Base
    include Pipedream::Dsl::IamRole

    def build
      evaluate_file(iam_role_path) if File.exist?(iam_role_path)
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
      # Based on the one created by CodePipeline Console
      [{
        "action"=>["iam:PassRole"],
        "resource"=>"*",
        "effect"=>"Allow",
        "condition"=>
          {"string_equals_if_exists"=>
            {"iam:passed_to_service"=>
              ["cloudformation.amazonaws.com",
               "elasticbeanstalk.amazonaws.com",
               "ec2.amazonaws.com",
               "ecs-tasks.amazonaws.com"]
            }
          }
      },{
        "action"=>
          ["codecommit:CancelUploadArchive",
           "codecommit:GetBranch",
           "codecommit:GetCommit",
           "codecommit:GetUploadArchiveStatus",
           "codecommit:UploadArchive"],
          "resource"=>"*",
          "effect"=>"Allow"
      },{
        "action"=>
         ["codedeploy:CreateDeployment",
          "codedeploy:GetApplication",
          "codedeploy:GetApplicationRevision",
          "codedeploy:GetDeployment",
          "codedeploy:GetDeploymentConfig",
          "codedeploy:RegisterApplicationRevision"],
          "resource"=>"*",
          "effect"=>"Allow"
      },{
        "action"=>
          ["elasticbeanstalk:*",
           "ec2:*",
           "elasticloadbalancing:*",
           "autoscaling:*",
           "cloudwatch:*",
           "s3:*",
           "sns:*",
           "cloudformation:*",
           "rds:*",
           "sqs:*",
           "ecs:*"],
        "resource"=>"*",
        "effect"=>"Allow"
      },{
        "action"=>["lambda:InvokeFunction", "lambda:ListFunctions"],
        "resource"=>"*",
        "effect"=>"Allow"
      },{
        "action"=>
           ["opsworks:CreateDeployment",
            "opsworks:DescribeApps",
            "opsworks:DescribeCommands",
            "opsworks:DescribeDeployments",
            "opsworks:DescribeInstances",
            "opsworks:DescribeStacks",
            "opsworks:UpdateApp",
            "opsworks:UpdateStack"],
          "resource"=>"*",
          "effect"=>"Allow"
      },{
        "action"=>
         ["cloudformation:CreateStack",
          "cloudformation:DeleteStack",
          "cloudformation:DescribeStacks",
          "cloudformation:UpdateStack",
          "cloudformation:CreateChangeSet",
          "cloudformation:DeleteChangeSet",
          "cloudformation:DescribeChangeSet",
          "cloudformation:ExecuteChangeSet",
          "cloudformation:SetStackPolicy",
          "cloudformation:ValidateTemplate"],
        "resource"=>"*",
        "effect"=>"Allow"
      },{
        "action"=>["codebuild:BatchGetBuilds", "codebuild:StartBuild"],
        "resource"=>"*",
        "effect"=>"Allow"
      },{
        "action"=>
          ["devicefarm:ListProjects",
           "devicefarm:ListDevicePools",
           "devicefarm:GetRun",
           "devicefarm:GetUpload",
           "devicefarm:CreateUpload",
           "devicefarm:ScheduleRun"],
          "resource"=>"*",
          "effect"=>"Allow",
      },{
        "action"=>
          ["servicecatalog:ListProvisioningArtifacts",
           "servicecatalog:CreateProvisioningArtifact",
           "servicecatalog:DescribeProvisioningArtifact",
           "servicecatalog:DeleteProvisioningArtifact",
           "servicecatalog:UpdateProduct"],
        "resource"=>"*",
        "effect"=>"Allow",
      },{
        "action"=>["cloudformation:ValidateTemplate"],
        "resource"=>"*",
        "effect"=>"Allow",
      },{
        "action"=>["ecr:DescribeImages"],
        "resource"=>"*",
        "effect"=>"Allow",
      }]
    end

  private
    def iam_role_path
      lookup_pipedream_file("iam_role.rb")
    end
  end
end
