# frozen_string_literal: true
module InsightsEngine
  module Schemas
    # Schema used to describe authors
    # This is populated based on the git details and git provided author name
    # and email
    # This schema should be used to validate all the authors of all the things
    Author = Dry::Validation.Schema(Base) do
      optional(:name).maybe(:str?)
      required(:email).filled(:str?)
    end
  end
end
