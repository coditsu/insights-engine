# frozen_string_literal: true
RSpec.describe InsightsEngine::Harvesters::GitInspector::Parser do
  specify { expect(described_class).to be < InsightsEngine::Engine::Parser }

  subject(:parser) { described_class.new }

  let(:stdout) do
    InsightsEngine::Harvesters::GitInspector::Harvester.new.call(
      InsightsEngine::Engine::Params.new(
        build_path: InsightsEngine.gem_root
      )
    )
  end

  before { parser.instance_variable_set(:'@raw', stdout) }

  describe '#process' do
    let(:output) { parser.send(:process) }

    it { expect(output).not_to be_empty }
    it { expect(output).to be_an_instance_of(Hash) }
    it { expect(output.count).to eq(4) }
    it { expect(output).to have_key(:extensions) }
    it { expect(output).to have_key(:metadata) }
    it { expect(output).to have_key(:statistics) }
    it { expect(output).to have_key(:responsibilities) }
  end
end
