# frozen_string_literal: true

module InsightsEngine
  module Schemas
    # Schema describing incoming parameters
    # We use it to validate input that we get from the outside of this gem
    Params = Dry::Validation.Schema(Base) do
      configure { predicates(Schemas::Predicates) }

      required(:build_path).filled(:str?, :absolute_path?)
    end
  end
end
