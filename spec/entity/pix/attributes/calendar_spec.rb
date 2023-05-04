RSpec.describe BradescoApi::Entity::Pix::Attributes::Calendar do
  describe "attr_accessors" do
    it "responds to attr_accessors" do
      calendar = BradescoApi::Entity::Pix::Attributes::Calendar.new(due_date: "2023-06-01", limit_after_due_date: 10, creation: "2023-05-01")
      expect(calendar).to respond_to(:due_date)
      expect(calendar).to respond_to(:due_date=)
      expect(calendar).to respond_to(:limit_after_due_date)
      expect(calendar).to respond_to(:limit_after_due_date=)
      expect(calendar).to respond_to(:creation)
      expect(calendar).to respond_to(:creation=)
    end
  end

  describe "#initialize" do
    context "with valid parameters" do
      it "sets the attributes correctly" do
        calendar = BradescoApi::Entity::Pix::Attributes::Calendar.new(due_date: "2023-06-01", limit_after_due_date: 10, creation: "2023-05-01")
        expect(calendar.due_date).to eq("2023-06-01")
        expect(calendar.limit_after_due_date).to eq(10)
        expect(calendar.creation).to eq("2023-05-01")
      end
    end
  end

  describe "#due_date" do
    context "when due date is set" do
      it "returns the correct value" do
        calendar = BradescoApi::Entity::Pix::Attributes::Calendar.new(due_date: "2023-06-01", limit_after_due_date: 10, creation: "2023-05-01")
        expect(calendar.due_date).to eq("2023-06-01")
      end
    end

    context "when due date is not set" do
      it "returns nil" do
        calendar = BradescoApi::Entity::Pix::Attributes::Calendar.new(due_date: nil, limit_after_due_date: 10, creation: "2023-05-01")
        expect(calendar.due_date).to be_nil
      end
    end
  end

  describe "#limit_after_due_date" do
    context "when limit after due date is set" do
      it "returns the correct value" do
        calendar = BradescoApi::Entity::Pix::Attributes::Calendar.new(due_date: "2023-06-01", limit_after_due_date: 10, creation: "2023-05-01")
        expect(calendar.limit_after_due_date).to eq(10)
      end
    end

    context "when limit after due date is not set" do
      it "returns nil" do
        calendar = BradescoApi::Entity::Pix::Attributes::Calendar.new(due_date: "2023-06-01", limit_after_due_date: nil, creation: "2023-05-01")
        expect(calendar.limit_after_due_date).to be_nil
      end
    end
  end

  describe "#creation" do
    context "when creation is set" do
      it "returns the correct value" do
        calendar = BradescoApi::Entity::Pix::Attributes::Calendar.new(due_date: "2023-06-01", limit_after_due_date: 10, creation: "2023-05-01")
        expect(calendar.creation).to eq("2023-05-01")
      end
    end

    context "when creation is not set" do
      it "returns an empty string" do
        calendar = BradescoApi::Entity::Pix::Attributes::Calendar.new(due_date: "2023-06-01", limit_after_due_date: 10, creation: nil)
        expect(calendar.creation).to eq("")
      end
    end
  end
end