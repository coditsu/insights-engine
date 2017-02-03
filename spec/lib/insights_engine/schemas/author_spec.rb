# frozen_string_literal: true
RSpec.describe InsightsEngine::Schemas::Author do
  subject(:schema_result) { described_class.call(input) }

  context 'no data' do
    let(:input) { {} }

    it do
      expect do
        schema_result
      end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
    end
  end

  context 'invalid types' do
    let(:input) { { name: rand, email: rand } }

    it do
      expect do
        schema_result
      end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
    end
  end

  context 'valid types' do
    let(:input) { { name: rand.to_s, email: rand.to_s } }

    it { expect { schema_result }.not_to raise_error }
  end

  context 'keys missing' do
    describe '#name' do
      let(:input) { { email: rand.to_s } }

      it { expect { schema_result }.not_to raise_error }
    end

    describe '#email' do
      let(:input) { { name: rand.to_s } }

      it do
        expect do
          schema_result
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end
  end

  context 'empty missing' do
    describe '#name' do
      let(:input) { { email: rand.to_s, name: '' } }

      it { expect { schema_result }.not_to raise_error }
    end

    describe '#email' do
      let(:input) { { name: rand.to_s, email: '' } }

      it do
        expect do
          schema_result
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end
  end

  context 'invalid key type' do
    describe '#name' do
      let(:input) { { email: rand.to_s, name: rand } }

      it do
        expect do
          schema_result
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end

    describe '#email' do
      let(:input) { { name: rand.to_s, email: rand } }

      it do
        expect do
          schema_result
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end
  end
end
