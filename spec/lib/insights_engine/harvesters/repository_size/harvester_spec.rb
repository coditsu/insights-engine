# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::RepositorySize::Harvester do
  subject(:harvester) { described_class.new }

  let(:scope) { InsightsEngine::Harvesters::RepositorySize }
  let(:params) do
    InsightsEngine::Engine::Params.new(
      build_path: SupportEngine::Git::RepoBuilder::Master.location,
      snapshotted_at: Date.today
    )
  end

  before { harvester.instance_variable_set(:'@params', params) }

  specify { expect(described_class).to be < InsightsEngine::Engine::Harvester }

  describe '#process' do
    let(:output) { harvester.send(:process) }

    it { expect(output).to be_an_instance_of(Hash) }
    it { expect(output[:stdout].keys).to eq %i[codebase_size total_size] }
  end
end
