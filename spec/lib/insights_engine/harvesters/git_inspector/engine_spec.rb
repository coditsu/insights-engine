# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::GitInspector::Engine do
  let(:scope) { InsightsEngine::Harvesters::GitInspector }
  let(:params) { { build_path: InsightsEngine.gem_root } }
  let(:input) do
    described_class.parser.new.call(
      described_class.harvester.new.call(
        InsightsEngine::Engine::Params.new(params)
      )
    )
  end

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
      it_behaves_like :schemas_spec_nested, metadata: {
        version: [:required, :filled],
        repository: [:required, :filled],
        report_date: [:required, :filled, :date]
      }

      it_behaves_like :schemas_spec_nested, statistics: {
        name: [:required],
        email: [:required, :filled, :str?],
        commits: [:required, :int?, gteq?: 0],
        insertions: [:required, :int?, gteq?: 0],
        deletions: [:required, :int?, gteq?: 0],
        age: [:required, :int?, gteq?: 0],
        stability: [:required, :int?, gteq?: 0],
        percentage_in_comments: [:required, :int?, gteq?: 0],
        rows: [:required, :int?, gteq?: 0]
      }

      it_behaves_like :schemas_spec_first, responsibilities: {
        email: [:required, :filled, :str?],
        location: [:required, :filled, :str?],
        rows: [:required, :int?, gteq?: 0]
      }
    end
  end
end
