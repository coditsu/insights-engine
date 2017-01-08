# frozen_string_literal: true
RSpec.describe InsightsEngine::Harvesters::Cloc::Engine do
  let(:scope) { InsightsEngine::Harvesters::Cloc }

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
end
