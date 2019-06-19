module Codepipe
  class CodebuildRole < Role
    def default_properties
      {
        assume_role_policy_document: {
          statement: [{
            action: ["sts:AssumeRole"],
            effect: "Allow",
            principal: {
              service: principal_services
            }
          }]
        },
        path: "/"
      }
    end

    def logical_id
      "CodeBuildRole"
    end

  private
    def get_role_path
      lookup_codepipeline_file("codebuild_role.rb")
    end

    def principal_services
      ["codebuild.amazonaws.com"]
    end
  end
end
