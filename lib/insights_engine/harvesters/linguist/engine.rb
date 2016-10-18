# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module Linguist
      class Engine < InsightsEngine::Engine
        self.parser = Linguist::Parser
        self.harvester = Linguist::Harvester
        self.schema = Dry::Validation.Schema(InsightsEngine::Schemas::Base) do
          required(:languages).value(:hash?)
        end
      end
    end
  end
end
