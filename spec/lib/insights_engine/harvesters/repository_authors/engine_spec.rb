# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::RepositoryAuthors::Engine do
  let(:scope) { InsightsEngine::Harvesters::RepositoryAuthors }
  let(:params) do
    {
      build_path: SupportEngine::Git::RepoBuilder::Master.location,
      snapshotted_at: Date.today
    }
  end
  let(:input) do
    described_class.parser.new.call(
      described_class.harvester.new.call(
        InsightsEngine::Engine::Params.new(params)
      )
    ).first
  end

  specify { expect(described_class).to be < InsightsEngine::Engine }
  specify { expect(described_class.harvester).to eq scope::Harvester }
  specify { expect(described_class.parser).to eq scope::Parser }

  describe 'integration' do
    subject(:result) do
      described_class.new.call(params)
    end

    it 'expect not to throw any errors' do
      expect { result }.not_to raise_error
    end
  end

  describe '#schema' do
    # We don't have to spec the schema here as we reuse the author schema
    it { expect(described_class.schema).to eq InsightsEngine::Schemas::Author }
  end
end
