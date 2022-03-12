module Pipedream::Dsl::Pipeline
  module Codebuild
    def codebuild(*projects)
      default = {
        # name: '', # will be set
        action_type_id: {
          category: "Build",
          owner: "AWS",
          provider: "CodeBuild",
          version: "1",
        },
        run_order: @run_order,
        # configuration: { project_name: '' }, # will be set
        # output_artifacts: [name: "BuildArtifact#{name}"], # TODO: maybe make this configurable with a setting
        input_artifacts: [name: "MainArtifact"],
      }

      actions = projects.map do |item|
        if item.is_a?(String)
          name = item
          default.deep_merge(
            name: name,
            configuration: { project_name: item },
          )
        else # Hash
          # With the hash notation, user needs to set: name and project_name
          #
          #   codebuild(name: "action-name", project_name: "codebuild-project-names")
          #
          project_name = item.delete(:project_name) || item[:name]
          if project_name
            item[:configuration] = { project_name: project_name }
          end

          item[:name] ||= project_name
          item.reverse_merge(default)
        end
      end

      action(*actions)
    end
  end
end
