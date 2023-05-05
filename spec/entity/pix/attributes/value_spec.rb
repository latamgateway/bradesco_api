RSpec.describe BradescoApi::Entity::Pix::Attributes::Value do
  let(:value) do
    described_class.new(
      original: '100.0',
      fine_for_delay: nil,
      tax: nil,
      discount: nil,
      reduction: nil
    )
  end

  it 'has the expected original value' do
    expect(value.original).to eq('100.0')
  end

  it 'has a nil fine for delay attribute' do
    expect(value.fine_for_delay).to be_nil
  end

  it 'has a nil tax attribute' do
    expect(value.tax).to be_nil
  end

  it 'has a nil discount attribute' do
    expect(value.discount).to be_nil
  end

  it 'has a nil reduction attribute' do
    expect(value.reduction).to be_nil
  end
end
