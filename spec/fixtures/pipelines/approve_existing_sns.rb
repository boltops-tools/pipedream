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
  approve(
    notification_arn: "arn:aws:sns:us-west-2:536766270177:hello-topic",
    custom_data: "Approve deployment",
  )
end

stage "Deploy" do
  codebuild "demo-deploy"
end
