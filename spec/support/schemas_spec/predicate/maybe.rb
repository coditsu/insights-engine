# frozen_string_literal: true

module SchemasSpec
  class Predicate
    # Maybe predicate schema test builder
    class Maybe
      class << self
        def build!(hash, predicates)
          return unless predicates.include?(:maybe)

          %i(str? int? date_time?).each do |key|
            next unless hash.key?(key)
            hash[key][:error].delete(nil)
          end
        end
      end
    end
  end
end
