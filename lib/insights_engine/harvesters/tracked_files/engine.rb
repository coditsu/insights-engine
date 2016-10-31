# frozen_string_literal: true
module InsightsEngine
  module Harvesters
    module TrackedFiles
      class Engine < InsightsEngine::Engine
        self.parser = TrackedFiles::Parser
        self.harvester = TrackedFiles::Harvester
        self.schema = Dry::Validation.Schema(InsightsEngine::Schemas::Base) do
          required(:tracked_files).value(:int?, gteq?: 0)
        end
      end
    end
  end
end
