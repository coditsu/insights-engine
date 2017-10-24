# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::RepositoryAuthors::Harvester do
  subject(:harvester) { described_class.new }

  let(:scope) { InsightsEngine::Harvesters::RepositoryAuthors }
  let(:params) do
    InsightsEngine::Engine::Params.new(
      build_path: SupportEngine::Git::RepoBuilder::MasterMultipleCommitters.location,
      snapshotted_at: Date.today
    )
  end

  before { harvester.instance_variable_set(:'@params', params) }

  specify { expect(described_class).to be < InsightsEngine::Engine::Harvester }

  describe '#process' do
    let(:output) { harvester.send(:process) }

    it { expect(output).to be_an_instance_of(Array) }
    # we expect at least two authors for the repository
    it { expect(output.count).to be >= 2 }
  end
end
