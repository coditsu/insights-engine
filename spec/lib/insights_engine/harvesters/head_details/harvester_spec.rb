# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::HeadDetails::Harvester do
  specify { expect(described_class).to be < InsightsEngine::Engine::Harvester }

  subject(:harvester) { described_class.new }

  let(:scope) { InsightsEngine::Harvesters::HeadDetails }
  let(:params) do
    InsightsEngine::Engine::Params.new(
      build_path: InsightsEngine.gem_root
    )
  end

  before { harvester.instance_variable_set(:'@params', params) }

  describe '#process' do
    let(:output) { harvester.send(:process) }

    it { expect(output).to have_key(:stdout) }
    it { expect(output[:stdout]).to have_key(:target) }
    it { expect(output[:stdout][:target]).to be_an_instance_of(Rugged::Commit) }
    it { expect(output[:stdout]).to have_key(:lines_stats) }
    it { expect(output[:stdout][:lines_stats]).to be_an_instance_of(Array) }
    it { expect(output[:stdout][:lines_stats].count).to eq(2) }
    it { expect(output).to have_key(:stderr) }
    it { expect(output[:stderr]).to be_empty }
    it { expect(output).to have_key(:exit_code) }
    it { expect(output[:exit_code]).to eq(0) }
  end
end
