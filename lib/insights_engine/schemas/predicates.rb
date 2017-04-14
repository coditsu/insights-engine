# frozen_string_literal: true

module InsightsEngine
  module Schemas
    # Custom predicates that validate outgoing data for schemas
    module Predicates
      include Dry::Logic::Predicates

      # This regexp describes an absolute path
      # Absolute path always needs to start with / and cannot end with /
      ABSOLUTE_PATH_REGEXP = %r{\A\/.*[^\/]\z}

      predicate(:absolute_path?) do |value|
        !ABSOLUTE_PATH_REGEXP.match(value).nil? && File.exist?(value)
      end
    end
  end
end
