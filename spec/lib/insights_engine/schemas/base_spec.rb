# frozen_string_literal: true
RSpec.describe InsightsEngine::Schemas::Base do
  subject(:schema_result) { described_class.new.call(input) }

  describe '#call' do
    let(:input) { {} }

    context 'when validations went ok' do
      it { expect { schema_result }.not_to raise_error }
    end
  end
end
