describe Pipedream::Webhook do
  let(:webhook) do
    Pipedream::Webhook.new(webhook_path: "spec/fixtures/app/.codepipeline/webhook.rb")
  end
  context "general" do
    it "builds up the template in memory" do
      template = webhook.run
      expect(template.keys).to eq ["Webhook"]
      expect(template["Webhook"]).to be_a(Hash)
    end
  end
end
