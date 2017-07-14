# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::CommitsDetails::Harvester do
  specify { expect(described_class).to be < InsightsEngine::Engine::Harvester }

  subject(:harvester) { described_class.new }

  let(:scope) { InsightsEngine::Harvesters::CommitsDetails }
  let(:params) do
    InsightsEngine::Engine::Params.new(
      build_path: InsightsEngine.gem_root,
      snapshotted_at: Date.today
    )
  end

  before { harvester.instance_variable_set(:'@params', params) }

  describe '#process' do
    let(:output) { harvester.send(:process) }

    it { expect(output).to have_key(:stdout) }
    it { expect(output[:stdout]).to have_key(:commits) }
    it { expect(output[:stdout][:commits]).not_to be_empty }
    it do
      expect(
        output[:stdout][:commits].first
      ).to be_an_instance_of(Rugged::Commit)
    end
    it { expect(output[:stdout]).to have_key(:shortstat) }
    it { expect(output[:stdout][:shortstat]).not_to be_empty }
    it { expect(output[:stdout][:branches]).not_to be_empty }
    it { expect(output[:stdout][:shortstat]).to be_an_instance_of(Array) }
    it { expect(output[:stdout][:branches]).to be_an_instance_of(Array) }
    it { expect(output).to have_key(:stderr) }
    it { expect(output[:stderr]).to be_empty }
    it { expect(output).to have_key(:exit_code) }
    it { expect(output[:exit_code]).to eq(0) }
  end
end
