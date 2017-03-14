# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitEffort
      class Harvester < Engine::Harvester
        ABOVE = 5
        THRESHOLD = 1.month

        private

        # @return [Hash] hash with raw result data
        def process
          head_committed_at = Git.head_committed_at(params.build_path)
          raw(Git.effort(params.build_path, head_committed_at - THRESHOLD, ABOVE))
        end
      end
    end
  end
end
