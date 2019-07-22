# frozen_string_literal: true

RSpec.describe_current do
  subject(:schema_result) { described_class.new.call(input) }

  let(:valid_input) { { build_path: SupportEngine::Git::RepoBuilder::Master.location } }

  let(:input) { valid_input }

  context 'when we have valid types' do
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
