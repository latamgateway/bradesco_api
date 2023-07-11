RSpec.describe BradescoApi::Entity::Pix::Charge do
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
          date: '2023-04-29',
          percentage_value: '0.02'
        ),
        BradescoApi::Entity::Pix::Attributes::FixedDateDiscount.new(
          date: '2023-04-29',
          percentage_value: '0.02'
        ),
        BradescoApi::Entity::Pix::Attributes::FixedDateDiscount.new(
          date: '2023-04-30',
          percentage_value: '0.05'
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

  let(:calendar) do
    BradescoApi::Entity::Pix::Attributes::Calendar.new(
      due_date: '2023-05-29',
      limit_after_due_date: 0
    )
  end

  let(:identifier) { "VTi5nHqioFzK3TWXvxGFvtuvri" }
  let(:pix_key) { "4581f4b7-957f-4aba-9ae8-c1c174e9452c" }
  let(:free_text) { "Informar matrícula" }

  subject(:charge) do
    described_class.new(
      identifier: identifier,
      customer: customer,
      value: value,
      free_text: free_text,
      calendar: calendar
    )
  end

  describe "#initialize" do
    context "with required parameters" do
      it "sets identifier" do
        expect(charge.identifier).to eq(identifier)
      end

      it "sets customer" do
        expect(charge.customer).to eq(customer)
      end

      it "sets value" do
        expect(charge.value).to eq(value)
      end

      it "sets free_text" do
        expect(charge.free_text).to eq(free_text)
      end
    end

    context "without required parameters" do
      it "raises ArgumentError without identifier" do
        expect {
          described_class.new(
            customer: customer,
            value: value,
            free_text: free_text
          )
        }.to raise_error(ArgumentError)
      end

      it "raises ArgumentError without customer" do
        expect {
          described_class.new(
            identifier: identifier,
            value: value,
            free_text: free_text
          )
        }.to raise_error(ArgumentError)
      end

      it "raises ArgumentError without value" do
        expect {
          described_class.new(
            identifier: identifier,
            customer: customer,
            free_text: free_text
          )
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "attr_accessors" do
    it { is_expected.to respond_to(:calendar) }
    it { is_expected.to respond_to(:locale) }
    it { is_expected.to respond_to(:customer) }
    it { is_expected.to respond_to(:value) }
    it { is_expected.to respond_to(:additional_information) }
    it { is_expected.to respond_to(:free_text) }
    it { is_expected.to respond_to(:qr_code_text) }
    it { is_expected.to respond_to(:identifier) }
  end

  describe '#serialize' do
    it 'serializes the object correctly' do
      expect(JSON.parse(charge.serialize, symbolize_names: true)).to eq({
          "calendario": {
            "dataDeVencimento":"2023-05-29","validadeAposVencimento": 0
          },
          "devedor":{
            "logradouro":"Rua Amoipira, 201",
            "cidade":"São Paulo",
            "uf":"SP",
            "cep":"04689070",
            "cpf":"35566101836",
            "nome":"João Paulo Alves Teixeira"
          },
          "valor":{
              "original":"5.00",
              "multa":{
                "modalidade":1,"valorPerc":"1.00"
              },
              "juros":{
                "modalidade":1,"valorPerc":"1.00"
              },
              "abatimento":{
                "modalidade":1,"valorPerc":"1.00"
              },
              "desconto":{
                "modalidade":1,"descontoDataFixa":[
                  {"data":"2023-04-29","valorPerc":"0.02"},
                  {"data":"2023-04-29","valorPerc":"0.02"},
                  {"data":"2023-04-30","valorPerc":"0.05"}
                ]
              }
            },
          "chave": ENV['BRADESCO_PIX_KEY'],
          "solicitacaoPagador":"Informar matrícula"
        }
      )
    end
  end
end
