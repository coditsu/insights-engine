# frozen_string_literal: true

module InsightsEngine
  module Harvesters
    # Namespace of a TrackedFiles harvester
    module TrackedFiles
      # Engine for gathring details about number of tracked files on a repository
      class Engine < InsightsEngine::Engine
        self.parser = TrackedFiles::Parser
        self.harvester = TrackedFiles::Harvester
        # Schema for final results format validation
        self.schema = Dry::Validation.Schema(InsightsEngine::Schemas::Base) do
          required(:tracked_files).value(:int?, gteq?: 0)
        end
      end
    end
  end
end
