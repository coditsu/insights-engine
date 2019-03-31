# frozen_string_literal: true

module SchemasSpec
  # Options builder for SchemasSpec helper
  class Options
    class << self
      # Builds configuration for SchemasSpec validation helper
      # @param name [Symbol] predicates for the attribute from schema
      # @param predicates [Array] predicates that we want to test
      # @param predicate [Symbol] current predicate
      # @param scope [Symbol] scope in which the attribute is
      # @return [Hash] hash with schema like keys and values on which it should succeed and error
      # @example
      #   prepare(:language, [:required, :filled, :str?], :required, :languages) #=>
      #     {
      #       :name => :language,
      #       :predicates => [:required, :filled, :str?],
      #       :scope => :languages,
      #       :predicate => :required,
      #       :predicate_value => 0
      #     }
      def prepare(name, predicates, predicate, scope = nil)
        options = { name: name, predicates: predicates, scope: scope }
        options[:predicate],
          options[:predicate_value] = clean_predicate(predicate)
        options
      end

      private

      # Returns predicate with value
      # @param predicate [Symbol, Hash] predicate
      # @return [Array] predicate with value
      # @example
      #   clean_predicate(:required) #=> [:required, 0]
      #   clean_predicate({:gteq?=>0}) #=> [:gteq?, 0]
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
