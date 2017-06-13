# frozen_string_literal: true

RSpec.describe InsightsEngine::Schemas::Params do
  subject(:schema_result) { described_class.call(input) }

  let(:valid_input) do
    {
      build_path: InsightsEngine.gem_root,
      snapshotted_at: Date.today
    }
  end

  let(:input) { valid_input }

  context 'valid types' do
    it { expect { schema_result }.not_to raise_error }
  end

  describe '#build_path' do
    context 'when it is not a string' do
      before { input[:build_path] = rand }

      it do
        expect do
          schema_result
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end

    context 'when it is not an absolute path' do
      before { input[:build_path] = "./#{rand}" }

      it do
        expect do
          schema_result
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end

    context 'when it is a non existing absolute path' do
      before { input[:build_path] = "/#{rand}" }

      it do
        expect do
          schema_result
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end
  end
end
