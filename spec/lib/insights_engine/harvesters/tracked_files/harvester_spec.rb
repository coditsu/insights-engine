# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::TrackedFiles::Harvester do
  specify { expect(described_class).to be < InsightsEngine::Engine::Harvester }

  subject(:harvester) { described_class.new }

  let(:path) { SupportEngine::Git::RepoBuilder::Master.location }
  let(:scope) { InsightsEngine::Harvesters::TrackedFiles }
  let(:params) do
    InsightsEngine::Engine::Params.new(
      build_path: path,
      snapshotted_at: Date.today
    )
  end

  before { harvester.instance_variable_set(:'@params', params) }

  describe '#process' do
    let(:output) { harvester.send(:process) }

    it { expect(output).to be_an_instance_of(Integer) }
    it { expect(output).to eq(1) }
  end
end
