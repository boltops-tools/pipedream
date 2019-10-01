describe Pipedream::Pipeline do
  let(:stack) do
    stack = Pipedream::Stack.new(
      pipeline_path: "spec/fixtures/pipelines/#{pipeline_example}.rb",
      stack_name: "fake", # to avoid .pipedream check in settings
    )
    allow(stack).to receive(:perform)
    allow(stack).to receive(:url_info)
    stack
  end

  context "pipeline with approve step without existing sns topic arn" do
    let(:pipeline_example) { "approve" }
    it "stack" do
      stack.run
      template = stack.instance_variable_get(:@template)
      # creates and manages the SnsTopic
      expect(template["Resources"]["SnsTopic"]).to be_a(Hash)
    end
  end

  context "pipeline with approve step with existing sns topic arn" do
    let(:pipeline_example) { "approve_existing_sns" }

    it "stack" do
      stack.run
      template = stack.instance_variable_get(:@template)
      # does not creates the SnsTopic
      expect(template["Resources"]["SnsTopic"]).to be nil
    end
  end
end
