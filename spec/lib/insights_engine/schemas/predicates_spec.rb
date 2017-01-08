# frozen_string_literal: true
RSpec.describe InsightsEngine::Schemas::Predicates do
  # We test it on something that includes our predicates
  subject(:schema_result) { InsightsEngine::Schemas::Params.call(input) }

  let(:input) do
    {
      build_path: build_path,
      settings_content: rand.to_s
    }
  end

  describe '#absolute_path?' do
    context 'valid sources path' do
      let(:build_path) { InsightsEngine.gem_root }

      it { expect { schema_result }.not_to raise_error }
    end

    context 'nil sources path' do
      let(:build_path) { nil }

      it { expect { schema_result }.to raise_error(InsightsEngine::Errors::InvalidAttributes) }
    end

    context 'local sources path' do
      let(:build_path) { './' }

      it { expect { schema_result }.to raise_error(InsightsEngine::Errors::InvalidAttributes) }
    end

    context 'absolute but non existing' do
      let(:build_path) { "/#{rand}" }

      it { expect { schema_result }.to raise_error(InsightsEngine::Errors::InvalidAttributes) }
    end
  end
end
