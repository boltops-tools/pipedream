module Pipedream::Dsl::Pipeline
  module Github
    def github(props)
      # nice shorthands
      source = props.delete(:source)
      source = extract_repo_source(source)
      owner,repo = source.split("/")

      # cli option can override this in codepipe/pipeline.rb set_source!
      # so cli option always gets the highest precendence
      branch = props.delete(:branch) || "master" # always delete branch prop

      o_auth_token = props.delete(:auth_token)
      poll_for_source_changes = props.delete(:poll_for_source_changes) || "false"

      source_name = props.delete(:source_name) || "Main"

      default = {
        name: source_name,
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
        output_artifacts: [name: source_name]
      }
      action(props.reverse_merge(default))
    end

    def extract_repo_source(url)
      url.sub('git@github.com:','').sub('https://github.com/','').sub(/\.git$/,'')
    end
    extend self # mainly for extract_repo_source
  end
end