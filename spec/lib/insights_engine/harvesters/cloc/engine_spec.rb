# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::Cloc::Engine do
  let(:scope) { InsightsEngine::Harvesters::Cloc }
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
      described_class.new.call(
        build_path: InsightsEngine.gem_root
      )
    end

    it 'expect not to throw any errors' do
      expect { result }.not_to raise_error
    end
  end

  describe '#schema' do
    context 'default data' do
      it { expect { described_class.schema.call(input) }.not_to raise_error }
    end

    context 'no data' do
      let(:input) { {} }

      it { expect { described_class.schema.call(input) }.not_to raise_error }
    end

    context 'invalid' do
      it_behaves_like :schemas_spec_first, languages: {
        language: [:required, :filled, :str?],
        files: [:required, :filled, :int?, gteq?: 0],
        blank: [:required, :filled, :int?, gteq?: 0],
        comment: [:required, :filled, :int?, gteq?: 0],
        code: [:required, :filled, :int?, gteq?: 0]
      }
    end
  end
end
