# frozen_string_literal: true
RSpec.describe InsightsEngine::Harvesters::RepositoryAuthors::Engine do
  let(:scope) { InsightsEngine::Harvesters::RepositoryAuthors }
  let(:params) { { build_path: InsightsEngine.gem_root } }

  specify { expect(described_class).to be < InsightsEngine::Engine }
  specify { expect(described_class.harvester).to eq scope::Harvester }
  specify { expect(described_class.parser).to eq scope::Parser }

  describe 'integration' do
    subject(:result) do
      described_class.new.call(params)
    end

    it 'expect not to throw any errors' do
      expect { result }.not_to raise_error
    end
  end

  let(:input) do
    described_class.parser.new.call(
      described_class.harvester.new.call(
        InsightsEngine::Engine::Params.new(params)
      )
    ).first
  end

  describe '#schema' do
    context 'valid' do
      it { expect { described_class.schema.call(input) }.not_to raise_error }
    end

    context 'no data' do
      let(:input) { {} }
      it do
        expect do
          described_class.schema.call(input)
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end

    context 'invalid' do
      it_behaves_like :schemas_spec, :name, :optional, :maybe, :str?
      it_behaves_like :schemas_spec, :email, :required, :filled, :str?
    end
  end
end
