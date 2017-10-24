# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::Linguist::Parser do
  subject(:parser) { described_class.new }

  let(:stdout) do
    InsightsEngine::Harvesters::Linguist::Harvester.new.call(
      InsightsEngine::Engine::Params.new(
        build_path: SupportEngine::Git::RepoBuilder::Master.location,
        snapshotted_at: Date.today
      )
    )
  end

  before { parser.instance_variable_set(:'@raw', stdout) }

  specify { expect(described_class).to be < InsightsEngine::Engine::Parser }

  describe '#process' do
    let(:output) { parser.send(:process) }

    it { expect(output).to be_an_instance_of(Hash) }
    it { expect(output.size).to eq(1) }
    it { expect(output).to have_key(:languages) }
  end
end
