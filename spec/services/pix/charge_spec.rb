RSpec.describe BradescoApi::Services::Pix::Charge do

  let(:customer) do
    BradescoApi::Entity::Pix::Attributes::Customer.new(
      address: "Rua Amoipira, 201",
      city: "São Paulo",
      state: "SP",
      zip_code: "04689070",
      document: "35566101836",
      name: "João Paulo Alves Teixeira"
    )
  end

  let(:common_attr) { { modality: 1, percentage_value: "1.00" } }
  let(:fine_for_delay) { BradescoApi::Entity::Pix::Attributes::FineForDelay.new(**common_attr) }
  let(:tax) { BradescoApi::Entity::Pix::Attributes::Tax.new(**common_attr) }
  let(:reduction) { BradescoApi::Entity::Pix::Attributes::Reduction.new(**common_attr) }

  let(:discount) do
    BradescoApi::Entity::Pix::Attributes::Discount.new(
      modality: 1,
      percentage_value: "1.00",
      fixed_date_discount: [
        BradescoApi::Entity::Pix::Attributes::FixedDateDiscount.new(
          date: '2023-05-18',
          percentage_value: '0.02'
        )
      ]
    )
  end

  let(:value) do
    BradescoApi::Entity::Pix::Attributes::Value.new(
      original: "5.00",
      fine_for_delay: fine_for_delay,
      tax: tax,
      reduction: reduction,
      discount: discount
    )
  end

  let(:due_date) {Time.new + 3 * 86400}

  let(:calendar) do
    BradescoApi::Entity::Pix::Attributes::Calendar.new(
      due_date: due_date.strftime("%Y-%m-%d").to_s,
      limit_after_due_date: 0
    )
  end

  let(:identifier) { "VTi5nHqioFzK3TWXvxGFvtuvre" }
  let(:pix_key) { "4581f4b7-957f-4aba-9ae8-c1c174e9452c" }
  let(:free_text) { "Informar matrícula" }

  let(:charge) { BradescoApi::Entity::Pix::Charge.new(
    identifier: identifier,
    customer: customer,
    value: value,
    pix_key: pix_key,
    free_text: free_text,
    calendar: calendar
  )}
  let(:http) { BradescoApi::Utils::HTTP.new }

  describe "#create" do
    it "returns a ChargeResponse if the request is successful" do
      response = VCR.use_cassette('put') do
        subject.create(charge)
      end

      expect(response).to be_a(BradescoApi::Entity::Pix::ChargeResponse)
    end

    
    it "returns an Errors::ResponseApi if the request is not successful" do
      wrongCharge = charge
      wrongCharge.calendar.due_date = "2023-05-05"

      error_response = VCR.use_cassette('put_error') do
        subject.create(wrongCharge)
      end
    
      expect(error_response).to be_a(BradescoApi::Entity::Errors::ResponseApi)
    end

  end

  describe "#get" do
    it "returns a ChargeResponse if the request is successful" do
      charge_response = VCR.use_cassette('get') do
        subject.get(identifier)
      end

      expect(charge_response).to be_a(BradescoApi::Entity::Pix::ChargeResponse)
    end

  end
end
