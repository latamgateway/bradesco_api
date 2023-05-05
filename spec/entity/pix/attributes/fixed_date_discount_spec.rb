RSpec.describe BradescoApi::Entity::Pix::Attributes::FixedDateDiscount do
  let(:fixed_date_discount) { described_class.new(date: '2023-05-04', percentage_value: '0.1') }

  describe '#initialize' do
    it 'initializes the date attribute correctly' do
      expect(fixed_date_discount.date).to eq('2023-05-04')
    end

    it 'initializes the percentage_value attribute correctly' do
      expect(fixed_date_discount.percentage_value).to eq('0.1')
    end
  end
end
