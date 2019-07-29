stage "Source" do
  github(
    source: "tongueroo/demo-test",
    branch: "master",
    auth_token: "fake",
  )
end

# codebuild_prefix "myprefix-"

stage "Build" do
  codebuild "demo-build"
end

stage "Approve" do
  # not specifying the SNS topic arn so codepipeline will create one
  approve("Approve deployment")
end

stage "Deploy" do
  codebuild "demo-deploy"
end
