RSpec.describe BradescoApi::Entity::Pix::Attributes::AdditionalInformation do
  describe "#initialize" do
    it "sets the instance variables correctly" do
      info = described_class.new(
        name: "Some name",
        value: "Some value"
      )

      expect(info.name).to eq("Some name")
      expect(info.value).to eq("Some value")
    end
  end

  describe "attribute accessors" do
    let(:info) do
      described_class.new(
        name: "Some name",
        value: "Some value"
      )
    end

    it "can get and set the name attribute" do
      info.name = "New name"
      expect(info.name).to eq("New name")
    end

    it "can get and set the value attribute" do
      info.value = "New value"
      expect(info.value).to eq("New value")
    end
  end
end
