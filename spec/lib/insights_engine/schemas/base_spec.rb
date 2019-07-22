# frozen_string_literal: true

RSpec.describe_current do
  specify { expect(described_class).to be < Dry::Validation::Contract }
end
