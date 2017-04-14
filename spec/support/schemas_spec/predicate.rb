# frozen_string_literal: true

module SchemasSpec
  class Predicate
    class << self
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
