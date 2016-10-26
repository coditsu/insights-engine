# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module Cloc
      class Engine < InsightsEngine::Engine
        self.parser = Cloc::Parser
        self.harvester = Cloc::Harvester
        self.schema = Dry::Validation.Schema(InsightsEngine::Schemas::Base) do
        end
      end
    end
  end
end
