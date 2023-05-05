RSpec.describe BradescoApi::Entity::Pix::Attributes::Customer do
  describe "#initialize" do
    it "sets the instance variables correctly" do
      customer = described_class.new(
        document: "12345678901",
        name: "John Doe",
        address: "123 Main St",
        city: "Anytown",
        state: "CA",
        zip_code: "12345",
        email: "johndoe@example.com"
      )

      expect(customer.document).to eq("12345678901")
      expect(customer.name).to eq("John Doe")
      expect(customer.address).to eq("123 Main St")
      expect(customer.city).to eq("Anytown")
      expect(customer.state).to eq("CA")
      expect(customer.zip_code).to eq("12345")
      expect(customer.email).to eq("johndoe@example.com")
    end
  end

  describe "attribute accessors" do
    let(:customer) do
      described_class.new(
        document: "12345678901",
        name: "John Doe",
        address: "123 Main St",
        city: "Anytown",
        state: "SP",
        zip_code: "12345",
        email: "johndoe@example.com"
      )
    end

    it "can get and set the address attribute" do
      customer.address = "456 Main St"
      expect(customer.address).to eq("456 Main St")
    end

    it "can get and set the city attribute" do
      customer.city = "Othertown"
      expect(customer.city).to eq("Othertown")
    end

    it "can get and set the state attribute" do
      customer.state = "NY"
      expect(customer.state).to eq("NY")
    end

    it "can get and set the zip code attribute" do
      customer.zip_code = "67890"
      expect(customer.zip_code).to eq("67890")
    end

    it "can get and set the name attribute" do
      customer.name = "Jane Doe"
      expect(customer.name).to eq("Jane Doe")
    end

    it "can get and set the email attribute" do
      customer.email = "janedoe@example.com"
      expect(customer.email).to eq("janedoe@example.com")
    end

    it "can get and set the document attribute" do
      customer.document = "98765432109"
      expect(customer.document).to eq("98765432109")
    end
  end
end
