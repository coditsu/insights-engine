module SchemasSpec
  class Predicate
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