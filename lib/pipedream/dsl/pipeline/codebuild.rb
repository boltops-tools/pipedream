module Pipedream::Dsl::Pipeline
  module Codebuild
    def codebuild(*projects)
      default = {
        # Name: '', # will be set
        ActionTypeId: {
          Category: "Build",
          Owner: "AWS",
          Provider: "CodeBuild",
          Version: "1",
        },
        RunOrder: @run_order,
        # Configuration: { ProjectName: '' }, # will be set
        # OutputArtifacts: [Name: "BuildArtifact#{name}"], # TODO: maybe make this configurable with a setting
        InputArtifacts: [Name: "MainArtifact"],
      }

      actions = projects.map do |item|
        if item.is_a?(String)
          name = item
          default.deep_merge(
            Name: name,
            Configuration: { ProjectName: item },
          )
        else # Hash
          # With the hash notation, user needs to set: name and ProjectName
          #
          #   codebuild(Name: "action-name", ProjectName: "codebuild-project-names")
          #
          project_name = item.delete(:ProjectName) || item[:Name]
          if !item[:Configuration] && project_name
            configuration = { ProjectName: project_name }
            configuration[:PrimarySource] = item.delete(:PrimarySource) || default[:InputArtifacts].first[:Name]
            item[:Configuration] = configuration
          end

          item[:Name] ||= project_name
          item.reverse_merge(default)
        end
      end

      action(*actions)
    end
  end
end
