# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module HeadDetails
      class Parser < Engine::Parser
        include InsightsEngine::Harvesters::CommitsDetails::ParserHelper

        def process
          target = raw.dig(:stdout, :target)
          lines_stats = raw.dig(:stdout, :lines_stats).last
          prepare(target, lines_stats)
        end
      end
    end
  end
end
