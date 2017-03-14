# frozen_string_literal: true
module InsightsEngine
  module Harvesters
    module TrackedFiles
      # Parser for extracting tracked files details out of raw results
      class Parser < Engine::Parser
        private

        # Transforms raw tracked files results into our internal format
        # @return [Hash] hash with tracked files details
        def process
          { tracked_files: raw.first.to_i }
        end
      end
    end
  end
end
