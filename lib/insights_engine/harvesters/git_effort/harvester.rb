# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitEffort
      class Harvester < Engine::Harvester
        ABOVE = 10

        private

        def process
          raw(Git.effort(params.build_path, ABOVE))
        end
      end
    end
  end
end
