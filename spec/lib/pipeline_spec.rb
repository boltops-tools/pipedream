describe Codepipe::Pipeline do
  let(:pipeline) do
    Codepipe::Pipeline.new(pipeline_path: "spec/fixtures/app/.codepipeline/pipeline.rb")
  end
  context "general" do
    it "builds up the template in memory" do
      template = pipeline.run
      expect(template.keys).to eq ["CodePipeline"]
      expect(template["CodePipeline"]).to be_a(Hash)
    end
  end
end
