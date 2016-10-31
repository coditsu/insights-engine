# frozen_string_literal: true
module InsightsEngine
  module Harvesters
    module TrackedFiles
      class Parser < Engine::Parser
        private

        def process
          { tracked_files: raw.first.to_i }
        end
      end
    end
  end
end
