# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitEffort
      class Harvester < Engine::Harvester
        ABOVE = 5
        THRESHOLD = 1.month

        private

        def process
          raw(Git.effort(params.build_path, THRESHOLD, ABOVE))
        end
      end
    end
  end
end
