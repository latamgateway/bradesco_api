RSpec.describe BradescoApi::Entity::Pix::Attributes::Locale do
  let(:locale) do
    described_class.new(
      id: 1,
      type: "cobv",
      location: "pix.example.com/qr/c2/cobv/9d36b84fc70b478fb95c12729b90ca25"
    )
  end

  describe '#id' do
    it 'returns the id' do
      expect(locale.id).to eq(1)
    end
  end

  describe '#type' do
    it 'returns the type' do
      expect(locale.type).to eq("cobv")
    end
  end

  describe '#location' do
    it 'returns the location' do
      expect(locale.location).to eq("pix.example.com/qr/c2/cobv/9d36b84fc70b478fb95c12729b90ca25")
    end
  end

  describe '#creation' do
    it 'returns the creation date' do
      expect(locale.creation).to eq("")
    end
  end
end
