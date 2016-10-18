# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module Linguist
      class Parser < Engine::Parser
        private

        def process
          { languages: raw[:stdout] }
        end
      end
    end
  end
end
