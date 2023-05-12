require 'json'

RSpec.describe BradescoApi::Entity::Pix::ChargeResponse do

  let(:response_payload) do
    "{\"cobv\": {
      \"calendario\": {
      \"criacao\": \"2020-09-09T20:15:00.358Z\",
      \"dataDeVencimento\": \"2020-12-31\",
      \"validadeAposVencimento\": 30
      },
      \"txid\": \"7978c0c97ea847e78e8849634473c1f1\",
      \"revisao\": 0,
      \"loc\": {
      \"id\": 789,
      \"location\": \"pix.example.com/qr/c2/cobv/9d36b84fc70b478fb95c12729b90ca25\",
      \"tipoCob\": \"cobv\",
      \"criacao\": \"2020-09-09T20:15:00.358Z\"
      },
      \"status\": \"ATIVA\",
      \"devedor\": {
      \"logradouro\": \"Rua 15, Numero 1, Bairro Luz\",
      \"cidade\": \"Belo Horizonte\",
      \"uf\": \"MG\",
      \"cep\": \"99000750\",
      \"cnpj\": \"12345678000195\",
      \"nome\": \"Empresa de Serviços SA\"
      },
      \"recebedor\": {
      \"logradouro\": \"Rua 15 Numero 1200, Bairro São Luiz\",
      \"cidade\": \"São Paulo\",
      \"uf\": \"SP\",
      \"cep\": \"70800100\",
      \"cnpj\": \"56989000019533\",
      \"nome\": \"Empresa de Logística SA\"
      },
      \"valor\": {
      \"original\": \"567.89\"
      },
      \"chave\": \"a1f4102e-a446-4a57-bcce-6fa48899c1d1\",
      \"solicitacaoPagador\": \"Informar cartão fidelidade\"
    }}"
  end

    describe 'attributes' do
      subject { described_class.new(response_payload) }

      it { is_expected.to have_attributes(revision: a_kind_of(Integer)) }
      it { is_expected.to have_attributes(status: a_kind_of(String)) }
      # it { is_expected.to have_attributes(emv: a_kind_of(String)) }
      it { is_expected.to have_attributes(free_text: a_kind_of(String)) }
      # it { is_expected.to have_attributes(base64: a_kind_of(String)) }
      it { is_expected.to have_attributes(seller: a_kind_of(BradescoApi::Entity::Pix::Attributes::Seller)) }
    end

    describe '#initialize' do
      context 'when the payload is valid' do
        it 'creates a new charge response object' do
          expect(described_class.new(response_payload)).to be_a(described_class)
        end
      end

      context 'when the payload is invalid' do
        let(:response_payload) { 'invalid payload' }

        it 'raises an error' do
          expect { described_class.new(response_payload) }.to raise_error(JSON::ParserError)
        end
      end
    end

    describe '#serialize' do

      let(:charge_response) { described_class.new(response_payload) }

      it 'raises a NoMethodError' do
        expect { charge_response.serialize }.to raise_error(NoMethodError)
      end
    end

end
