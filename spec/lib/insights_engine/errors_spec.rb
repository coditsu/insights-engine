# frozen_string_literal: true
RSpec.describe InsightsEngine::Errors do
  subject(:errors_module) { described_class }

  error_classes = described_class
                  .constants
                  .map { |c| described_class.const_get(c) }

  error_classes.each do |error_class|
    it "expect #{error_class} to inherit from base" do
      expect(error_class).to be <= errors_module::Base
    end
  end
end
