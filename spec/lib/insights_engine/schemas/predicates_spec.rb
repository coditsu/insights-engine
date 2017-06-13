# frozen_string_literal: true

RSpec.describe InsightsEngine::Schemas::Predicates do
  # We test it on something that includes our predicates
  subject(:schema_result) { InsightsEngine::Schemas::Params.call(input) }

  let(:input) do
    {
      build_path: build_path,
      snapshotted_at: Date.today
    }
  end

  describe '#absolute_path?' do
    context 'valid sources path' do
      let(:build_path) { InsightsEngine.gem_root }

      it { expect { schema_result }.not_to raise_error }
    end

    context 'nil sources path' do
      let(:build_path) { nil }

      it do
        expect do
          schema_result
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end

    context 'local sources path' do
      let(:build_path) { './' }

      it do
        expect do
          schema_result
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end

    context 'absolute but non existing' do
      let(:build_path) { "/#{rand}" }

      it do
        expect do
          schema_result
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end
  end
end
