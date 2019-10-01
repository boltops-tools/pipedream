module Codepipe::Dsl::Pipeline
  module Github
    def github(props)
      # nice shorthands
      source = props.delete(:source)
      owner,repo = source.split("/")

      # cli option can override this in codepipe/pipeline.rb set_source!
      # so cli option always gets the highest precendence
      branch = props.delete(:branch) || "master" # always delete branch prop

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