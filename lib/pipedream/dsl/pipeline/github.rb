module Pipedream::Dsl::Pipeline
  module Github
    def github(props)
      # nice shorthands
      source = props.delete(:Source)
      source = extract_repo_source(source)
      owner,repo = source.split("/")

      # cli option can override this in codepipe/pipeline.rb set_source!
      # so cli option always gets the highest precendence
      branch = props.delete(:Branch) || "master" # always delete branch prop

      o_auth_token = props.delete(:AuthToken)
      poll_for_source_changes = props.delete(:PollForSourceChanges) || "false"

      source_name = props.delete(:SourceName) || "Main"

      default = {
        Name: source_name,
        ActionTypeId: {
          Category: "Source",
          Owner: "ThirdParty",
          Provider: "GitHub",
          Version: "1",
        },
        RunOrder: @run_order,
        Configuration: {
          Branch: branch,
          OAuthToken: o_auth_token,
          Owner: owner,
          PollForSourceChanges: poll_for_source_changes,
          Repo: repo,
        },
        OutputArtifacts: [Name: source_name]
      }
      action(props.reverse_merge(default))
    end

    def extract_repo_source(url)
      url.sub('git@github.com:','').sub('https://github.com/','').sub(/\.git$/,'')
    end
    extend self # mainly for extract_repo_source
  end
end