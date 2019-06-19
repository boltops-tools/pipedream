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
        output_artifacts: [name: "SourceArtifact"]
      }
      action(props.reverse_merge(default))
    end

    def codebuild(*args)
      props = args.last.is_a?(Hash) ? args.pop : {}
      names = args # codebuild project names

      actions = names.map do |name|
        project_name = get_project_name(name)
        default = {
          name: name.underscore.camelize,
          action_type_id: {
            category: "Build",
            owner: "AWS",
            provider: "CodeBuild",
            version: "1",
          },
          run_order: @run_order,
          configuration: { project_name: project_name },
          # output_artifacts: [name: "BuildArtifact#{name}"], # TODO: maybe make this configurable with a setting
          input_artifacts: props[:input_artifacts] || [name: "SourceArtifact"],
        }
        props.reverse_merge(default)
      end

      action(*actions)
    end

    def codebuild_prefix(v)
      @codebuild_prefix = v
    end

    def codebuild_suffix(v)
      @codebuild_suffix = v
    end

  private
    def get_project_name(name)
      [@codebuild_prefix, name, @codebuild_suffix].compact.join
    end
  end
end
