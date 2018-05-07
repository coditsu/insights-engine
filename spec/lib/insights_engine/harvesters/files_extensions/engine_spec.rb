# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::FilesExtensions::Engine do
  let(:scope) { InsightsEngine::Harvesters::FilesExtensions }
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
    )
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
    context 'when we have valid data' do
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
      it_behaves_like 'schemas spec first', files_extensions: {
        name: %i[required filled str?],
        count: [:required, :filled, :int?, gt?: 0]
      }
    end
  end
end
