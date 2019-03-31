# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module HeadDetails
      # Parser for extracting head commit details out of raw results
      class Parser < Engine::Parser
        include InsightsEngine::Harvesters::HeadDetails::ParserHelper

        private

        # @return [Hash] hash with head commit details
        def process
          raw
            .dig(:stdout, :target)
            .then(&method(:prepare))
            .merge!(
              branch: raw.dig(:stdout, :branch),
              diff_hash: raw.dig(:stdout, :diff_hash)
            )
        end
      end
    end
  end
end
