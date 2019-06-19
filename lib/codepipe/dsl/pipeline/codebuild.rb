require "active_support/core_ext/hash"

module Codepipe::Dsl::Pipeline
  module Codebuild
    def github(props)
      # nice shorthands
      source = props.delete(:source)
      owner,repo = source.split("/")
      branch = props.delete(:branch) || master
      o_auth_token = props.delete(:auth_token)
      poll_for_source_changes = props.delete(:poll_for_source_changes) || "false"

      default = {
        name: "Source",
        action_type_id: {
          category: "Source",
          owner: "ThirdParty",
          provider: "GitHub",
          version: "1",
        },
        run_order: @run_order,
        configuration: {
          branch: branch,
          o_auth_token: o_auth_token,
          owner: owner,
          poll_for_source_changes: poll_for_source_changes,
          repo: repo,
        },
        output_artifacts: [name: "SourceArtifact"] # TODO: auto-generate
      }
      action(props.reverse_merge(default))
    end

    def codebuild(*args)
      props = args.last.is_a?(Hash) ? args.pop : {}
      pipeline_names = args
      pp pipeline_names

      actions = pipeline_names.map do |pipeline_name|
        name = pipeline_name.underscore.camelize
        default = {
          name: name,
          action_type_id: {
            category: "Build",
            owner: "AWS",
            provider: "CodeBuild",
            version: "1",
          },
          run_order: @run_order,
          # configuration: { pipeline_name: pipeline_name },
          configuration: { pipeline_name: "demo" }, # TODO: hard code for testing
          output_artifacts: [name: "BuildArtifact#{name}"],
          input_artifacts: props[:input_artifacts] || [name: "SourceArtifact"], # TODO: auto-generate
          # SourceArtifact88 ? Parse last stage and look for output artifact?
        }
        props.reverse_merge(default)
      end

      action(*actions)
    end
  end
end
