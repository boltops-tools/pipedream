describe Pipedream::Role do
  let(:role) do
    Pipedream::Role.new(role_path: "spec/fixtures/app/.codepipeline/role.rb")
  end
  context "general" do
    it "builds up the template in memory" do
      template = role.run
      expect(template.keys).to eq ["IamRole"]
      expect(template["IamRole"]).to be_a(Hash)
    end
  end
end
