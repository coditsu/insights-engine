# frozen_string_literal: true
RSpec.describe InsightsEngine::Harvesters::GitEffort::Parser do
  specify { expect(described_class).to be < InsightsEngine::Engine::Parser }

  subject(:parser) { described_class.new }

  let(:stdout) do
    InsightsEngine::Harvesters::GitEffort::Harvester.new.call(
      InsightsEngine::Engine::Params.new(
        build_path: InsightsEngine.gem_root
      )
    )
  end

  before { parser.instance_variable_set(:'@raw', stdout) }

  describe '#process' do
    let(:output) { parser.send(:process) }

    it { expect(output).not_to be_empty }
    it { expect(output).to be_an_instance_of(Array) }
    it { expect(output.count).to eq(3) }
    it { expect(output.first).to be_an_instance_of(Hash) }
    it { expect(output.first.keys.count).to eq(3) }
    it { expect(output.first).to have_key(:location) }
    it { expect(output.first).to have_key(:commits) }
    it { expect(output.first).to have_key(:active_days) }
  end
end
