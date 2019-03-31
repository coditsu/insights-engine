# frozen_string_literal: true

RSpec.describe InsightsEngine::Engine::Params do
  let(:args) { { build_path: SupportEngine::Git::RepoBuilder::Master.location } }

  describe '#initialize' do
    subject(:params) { described_class.new(args) }

    context 'when schema is invalid' do
      let(:args) { {} }

      it do
        expect do
          params
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end

    context 'when schema is valid' do
      it { expect { params }.not_to raise_error }
    end
  end
end
