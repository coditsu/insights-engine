# frozen_string_literal: true

module InsightsEngine
  module Schemas
    # Schema describing incoming parameters
    # We use it to validate input that we get from the outside of this gem
    Params = Dry::Validation.Schema(Base) do
      configure { predicates(Schemas::Predicates) }

      # Location of sources for which we want to build statistics
      required(:build_path).filled(:str?, :absolute_path?)
      # Default branch is required only to fetch head details, otherwise we don't need that
      # information, so it is optional
      optional(:default_branch).filled(:str?)
    end
  end
end
