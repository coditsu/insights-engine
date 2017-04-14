# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module Linguist
      # Parser for extracting linguist details out of raw results
      class Parser < Engine::Parser
        private

        # Transforms raw linguist details into our internal schema acceptable format
        # Since linguist runs from this process (it's a gem) the only thing we have to
        # do is to extract it out of stdout nad wrap in a hash
        # @return [Hash] linguist distribution details
        def process
          { languages: raw[:stdout] }
        end
      end
    end
  end
end
