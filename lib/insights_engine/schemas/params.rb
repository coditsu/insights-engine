# frozen_string_literal: true

module InsightsEngine
  module Schemas
    # Schema describing incoming parameters
    # We use it to validate input that we get from the outside of this gem
    Params = Dry::Validation.Schema(Base) do
      configure { predicates(Schemas::Predicates) }

      # Location of sources for which we want to build statistics
      required(:build_path).filled(:str?, :absolute_path?)
      # Date for which we want to get current state of code
      # @note This might differ from the current commit date, because we might build statistics
      # on a different date that commit was made (for example when we have a repo that is not
      # frequently updated)
      required(:snapshotted_at).filled(:date?)
      # Date from which we want to fetch git data. It is optional as it will fallback to
      # snapshotted_at - 2.days but sometimes we want to get an explicit range
      optional(:since).filled(:date?)
    end
  end
end
