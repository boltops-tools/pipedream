module Codepipe::Dsl::Pipeline
  module Github
    def github(props)
      # nice shorthands
      source = props.delete(:source)
      owner,repo = source.split("/")
      branch = props.delete(:branch) || "master"
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
        output_artifacts: [name: "SourceArtifact"]
      }
      action(props.reverse_merge(default))
    end
  end
end