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
        input_artifacts: [name: "SourceArtifact"],
      }

      actions = projects.map do |item|
        if item.is_a?(String)
          name = item.underscore.camelize
          default.deep_merge(
            name: name,
            configuration: { project_name: name },
          )
        else # Hash
          # With the hash, the user needs to set: name and configuration.project_name

          # Handy shorthands
          # The project name will allow this syntax
          #   codebuild(name: "action-name", project_name: "codebuild-project-names")
          project_name = item.delete(:project_name)
          if project_name
            item[:configuration] = { project_name: project_name }
          end

          item.reverse_merge(default)
        end
      end

      action(*actions)
    end
  end
end
