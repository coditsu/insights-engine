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
          prepare(
            raw.dig(:stdout, :target),
            raw.dig(:stdout, :lines_stats).last,
            raw.dig(:stdout, :branch)
          )
        end
      end
    end
  end
end
