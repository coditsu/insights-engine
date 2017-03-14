# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module HeadDetails
      # Parser for extracting head commit details out of raw results
      class Parser < Engine::Parser
        include InsightsEngine::Harvesters::CommitsDetails::ParserHelper

        private

        # @return [Hash] hash with head commit details
        def process
          target = raw.dig(:stdout, :target)
          lines_stats = raw.dig(:stdout, :lines_stats).last
          prepare(target, lines_stats)
        end
      end
    end
  end
end
