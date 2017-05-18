# frozen_string_literal: true

module SchemasSpec
  class Predicate
    # Maybe predicate schema test builder
    class Maybe
      class << self
        # Builds maybe predicate test cases
        # @param hash [Hash] configuration on which validation should succeed and error
        # @param predicates [Hash] predicates for the attribute from schema
        # @return [Hash] schema like configuration with modified values for maybe predicates
        def build!(hash, predicates)
          return unless predicates.include?(:maybe)

          %i[str? int? date_time?].each do |key|
            next unless hash.key?(key)
            hash[key][:error].delete(nil)
          end
        end
      end
    end
  end
end
