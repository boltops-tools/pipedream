describe Codepipe::CLI do
  before(:all) do
    @args = "--noop"
    @old_root = Dir.pwd
    Dir.chdir("spec/fixtures/app")
    @pipe_bin = "../../../exe/pipe"
  end
  after(:all) do
    Dir.chdir(@old_root)
  end

  describe "pipe" do
    it "deploy" do
      out = execute("#{@pipe_bin} deploy #{@args}")
      expect(out).to include("Generated CloudFormation template")
    end
  end
end
