RSpec.describe BradescoApi::Entity::Pix::Attributes::CommonFieldsValue do
  describe "#initialize" do
    it "sets the instance variables correctly" do
      common_fields_value = described_class.new(
        modality: 1,
        percentage_value: "25.00"
      )

      expect(common_fields_value.modality).to eq(1)
      expect(common_fields_value.percentage_value).to eq("25.00")
    end
  end

  describe "attribute accessors" do
    let(:common_fields_value) do
      described_class.new(
        modality: 1,
        percentage_value: "25.00"
      )
    end

    it "can get and set the modality attribute" do
      common_fields_value.modality = 2
      expect(common_fields_value.modality).to eq(2)
    end

    it "can get and set the percentage_value attribute" do
      common_fields_value.percentage_value = "50.00"
      expect(common_fields_value.percentage_value).to eq("50.00")
    end
  end
end
