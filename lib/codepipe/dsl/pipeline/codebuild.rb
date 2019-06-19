require "active_support/core_ext/hash"

module Codepipe::Dsl::Pipeline
  module Codebuild
    def github(props)
      owner,repo = props[:source].split("/")

      action(
        name: "Source", # TODO: auto-generate
        action_type_id: {
          category: "Source",
          owner: "ThirdParty",
          provider: "GitHub",
          version: "1",
        },
        run_order: 1, # TODO: auto-generate
        configuration: {
          branch: props[:branch] || "master",
          o_auth_token: props[:auth_token],
          owner: owner,
          poll_for_source_changes: props[:poll_for_source_changes] || "false",
          repo: repo,
        },
        output_artifacts: [name: "SourceArtifact1"] # TODO: auto-generate
      )
    end

    def codebuild(*args)
      props = args.last.is_a?(Hash) ? args.pop : {}
      project_names = args
      pp project_names

      actions = project_names.map do |project_name|
        name = project_name.underscore.camelize
        default = {
          name: name,
          action_type_id: {
            category: "Build",
            owner: "AWS",
            provider: "CodeBuild",
            version: "1",
          },
          run_order: @run_order,
          configuration: { project_name: project_name },
          output_artifacts: [name: "BuildArtifact#{name}"],
          input_artifacts: props[:input_artifacts] || [name: "SourceArtifact88"], # TODO: auto-generate
          # SourceArtifact88 ? Parse last stage and look for output artifact?
        }
        props.reverse_merge(default)
      end

      action(*actions)
    end
  end
end
