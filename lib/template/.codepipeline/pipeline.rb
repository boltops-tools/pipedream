stage "Source" do
  github(
    source: "...",
    branch: "master",
    auth_token: ssm("/codebuild/oauth_token") # example ssm name
  )
end

# codebuild_prefix "myprefix-"

# Example below:

# stage "Build" do
#   codebuild "action1"
#   codebuild "action2", "action3"
# end

# stage "Deploy" do
#   codebuild "action4"
# end
