stage "Source" do
  github(
    source: "tongueroo/demo-cb",
    branch: "master",
    auth_token: "fake",
  )
end
stage "DeployStacks" do
  codebuild "demo1"           # action declaration
  codebuild "demo2", "demo3"  # will run in parallel. run_order=2
  codebuild "demo4"           # action declaration
end
