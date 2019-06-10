# frozen_string_literal: true

RSpec.describe InsightsEngine::Schemas::Base do
  specify { expect(described_class).to be < Dry::Validation::Contract }
end
