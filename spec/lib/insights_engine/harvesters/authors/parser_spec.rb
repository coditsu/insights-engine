# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::Authors::Parser do
  subject(:parser) { described_class.new }

  let(:stdout) do
    InsightsEngine::Harvesters::Authors::Harvester.new.call(
      InsightsEngine::Engine::Params.new(
        build_path: SupportEngine::Git::RepoBuilder::MasterMultipleCommitters.location,
        snapshotted_at: Date.today
      )
    )
  end

  before { parser.instance_variable_set(:'@raw', stdout) }

  specify { expect(described_class).to be < InsightsEngine::Engine::Parser }

  describe '#process' do
    let(:output) { parser.send(:process) }

    it { expect(output).not_to be_empty }
    it { expect(output).to be_an_instance_of(Array) }
    # we expect at least two authors for the repository
    it { expect(output.count).to be >= 2 }
  end
end
