# frozen_string_literal: true

module InsightsEngine
  module Schemas
    # Schema describing incoming parameters
    # We use it to validate input that we get from the outside of this gem
    class Params < Base
      # This regexp describes an absolute path
      # Absolute path always needs to start with / and cannot end with /
      ABSOLUTE_PATH_REGEXP = %r{\A\/.*[^\/]\z}.freeze

      private_constant :ABSOLUTE_PATH_REGEXP

      params do
        required(:build_path).filled(:str?)
        # Location of sources for which we want to build statistics
        # Default branch is required only to fetch head details, otherwise we don't need that
        # information, so it is optional
        optional(:default_branch).filled(:str?)
      end

      rule(:build_path) do
        if value && (ABSOLUTE_PATH_REGEXP.match(value).nil? || !File.exist?(value))
          key(:build_path).failure(:not_an_absolute_path)
        end
      end
    end
  end
end
