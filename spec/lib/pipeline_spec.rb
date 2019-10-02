describe Pipedream::Pipeline do
  let(:pipeline) do
    Pipedream::Pipeline.new(pipeline_path: "spec/fixtures/app/.pipedream/pipeline.rb")
  end
  context "general" do
    it "builds up the template in memory" do
      template = pipeline.run
      expect(template.keys).to eq ["Pipeline"]
      expect(template["Pipeline"]).to be_a(Hash)
    end
  end
end
