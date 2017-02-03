module SchemasSpec
  class Options
    class << self
      def prepare(name, predicates, predicate, scope = nil)
        options = { name: name, predicates: predicates, scope: scope }
        options[:predicate],
          options[:predicate_value] = clean_predicate(predicate)
        options
      end

      def clean_predicate(predicate)
        case predicate
        when Hash then
          predicate.to_a.flatten
        else
          [predicate, 0]
        end
      end
    end
  end
end
