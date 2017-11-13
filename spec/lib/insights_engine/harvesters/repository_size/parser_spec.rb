# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::RepositorySize::Parser do
  subject(:parser) { described_class.new }

  let(:stdout) do
    InsightsEngine::Harvesters::RepositorySize::Harvester.new.call(
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

    it { expect(output[:codebase_size]).to be > 0 }
    it { expect(output[:total_size]).to be > 0 }
    it { expect(output[:total_size]).to be > output[:codebase_size] }
    it { expect(output).to be_an_instance_of(Hash) }
  end
end
