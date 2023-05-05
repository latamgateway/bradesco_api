RSpec.describe BradescoApi::Entity::Pix::Attributes::Discount do
  describe "#initialize" do
    it "sets the instance variables correctly" do
      fixed_date_discount = [
        BradescoApi::Entity::Pix::Attributes::FixedDateDiscount.new(
          date: "2023-04-28",
          percentage_value: "0.01"
        )
      ]
      discount = described_class.new(
        modality: 1,
        percentage_value: "25.00",
        fixed_date_discount: fixed_date_discount
      )

      expect(discount.modality).to eq(1)
      expect(discount.percentage_value).to eq("25.00")
      expect(discount.fixed_date_discount).to eq(fixed_date_discount)
    end
  end

  describe "attribute accessors" do
    let(:fixed_date_discount) do
      [
        BradescoApi::Entity::Pix::Attributes::FixedDateDiscount.new(
          date: '2023-04-28',
          percentage_value: '0.01'
        )
      ]
    end

    let(:discount) do
      described_class.new(
        modality: 1,
        percentage_value: "25.00",
        fixed_date_discount: fixed_date_discount
      )
    end

    it "can get and set the modality attribute" do
      discount.modality = 2
      expect(discount.modality).to eq(2)
    end

    it "can get and set the percentage_value attribute" do
      discount.percentage_value = "50.00"
      expect(discount.percentage_value).to eq("50.00")
    end

    it "can get and set the fixed_date_discount attribute" do
      new_fixed_date_discount = [
        BradescoApi::Entity::Pix::Attributes::FixedDateDiscount.new(
          date: '2023-05-05',
          percentage_value: '0.02'
        )
      ]
      discount.fixed_date_discount = new_fixed_date_discount
      expect(discount.fixed_date_discount).to eq(new_fixed_date_discount)
    end
  end
end
