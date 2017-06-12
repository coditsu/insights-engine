# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitEffort
      # Harvester used to get git effort details
      class Harvester < Engine::Harvester
        # Level above which we want to get efforts
        ABOVE = 5
        # How long back in history do we calculate effort
        THRESHOLD = 1.month

        private

        # @return [Hash] hash with raw result data
        def process
          head_committed_at = SupportEngine::Git::Log.head_committed_at(params.build_path)
          raw(
            SupportEngine::Git::Extras.effort(
              params.build_path,
              head_committed_at - THRESHOLD,
              ABOVE
            )
          )
        end
      end
    end
  end
end
