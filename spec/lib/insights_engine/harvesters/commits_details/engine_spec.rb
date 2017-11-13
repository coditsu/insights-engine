# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::CommitsDetails::Engine do
  let(:scope) { InsightsEngine::Harvesters::CommitsDetails }
  let(:params) do
    {
      build_path: SupportEngine::Git::RepoBuilder::Master.location,
      snapshotted_at: Date.today,
      since: 1.year.ago.to_date
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
    subject(:result) { described_class.new.call(params) }

    it 'expect not to throw any errors' do
      expect { result }.not_to raise_error
    end
  end

  describe '#schema' do
    context 'when we have default data' do
      it { expect { described_class.schema.call(input) }.not_to raise_error }
    end

    context 'when we have no data' do
      let(:input) { {} }

      it do
        expect do
          described_class.schema.call(input)
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end

    context 'when we have invalid data' do
      it_behaves_like :schemas_spec, :commit_hash, :required, :filled, :str?
      it_behaves_like :schemas_spec, :message, :required
      it_behaves_like :schemas_spec_nested, author: {
        name: %i[optional maybe str?],
        email: %i[required filled str?]
      }
      it_behaves_like :schemas_spec_nested, committer: {
        name: %i[optional maybe str?],
        email: %i[required filled str?]
      }
      it_behaves_like :schemas_spec, :authored_at, :required, :filled, :date_time?
      it_behaves_like :schemas_spec, :committed_at, :required, :filled, :date_time?
      it_behaves_like :schemas_spec, :files_changed, :required, :filled, :int?, gteq?: 0
      it_behaves_like :schemas_spec, :insertions, :required, :filled, :int?, gteq?: 0
      it_behaves_like :schemas_spec, :deletions, :required, :filled, :int?, gteq?: 0
    end
  end
end
