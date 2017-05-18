# frozen_string_literal: true

module SchemasSpec
  # Predicate builder
  class Predicate
    class << self
      # Builds a hash with values based on predicates we want to test against
      # @param predicates [Hash] predicates for the attribute from schema
      # @return [Hash] hash with schema like keys and values on which it should succeed and error
      # @example
      #   build([:optional, :maybe, :str?]) #=>
      #   {
      #     :filled => { :success => [], :error => [""] },
      #     :optional => { :success => [nil, ""], :error => [] },
      #     :str? => { :success => ["Test"], :error => [0] },
      #     :date_time? => { :success => [Thu, 18 May 2017 12:59:05 +0200], :error => ["", -1] }
      #   }
      def build(predicates)
        hash = {
          # add nil add 'Test' or 'int' or whatever based on other predicate
          filled: { success: [], error: [''] },
          optional: { success: [nil, ''], error: [] },
          str?: { success: ['Test'], error: [nil, 0] },
          date_time?: { success: [Time.now.to_datetime], error: [nil, '', -1] }
        }

        Integer.build!(hash, predicates)
        Maybe.build!(hash, predicates)

        hash
      end
    end
  end
end
