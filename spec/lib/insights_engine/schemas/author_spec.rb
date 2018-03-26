# frozen_string_literal: true

RSpec.describe InsightsEngine::Schemas::Author do
  subject(:schema_result) { described_class.call(input) }

  context 'when we have no data' do
    let(:input) { {} }

    it do
      expect do
        schema_result
      end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
    end
  end

  context 'when we have invalid types' do
    let(:input) { { name: rand, email: rand } }

    it do
      expect do
        schema_result
      end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
    end
  end

  context 'when we have valid types' do
    let(:input) { { name: rand.to_s, email: rand.to_s } }

    it { expect { schema_result }.not_to raise_error }
  end

  context 'when we have keys missing' do
    describe '#name' do
      let(:input) { { email: rand.to_s } }

      it do
        expect do
          schema_result
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
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

  context 'when we have values missing' do
    describe '#name' do
      let(:input) { { email: rand.to_s, name: nil } }

      it do
        expect do
          schema_result
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end

    describe '#email' do
      let(:input) { { name: rand.to_s, email: nil } }

      it do
        expect do
          schema_result
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end
  end

  context 'when we have empty missing' do
    describe '#name' do
      let(:input) { { email: rand.to_s, name: '' } }

      it { expect { schema_result }.not_to raise_error }
    end

    describe '#email' do
      let(:input) { { name: rand.to_s, email: '' } }

      it { expect { schema_result }.not_to raise_error }
    end
  end

  context 'when we have invalid key type' do
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
