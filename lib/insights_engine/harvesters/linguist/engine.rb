# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    # Namespace of a Linguist harvester
    module Linguist
      # Engine for getting code languages distribution using linguist
      # @see https://github.com/github/linguist
      class Engine < InsightsEngine::Engine
        self.parser = Linguist::Parser
        self.harvester = Linguist::Harvester
        # Schema for final results format validation
        self.schema = Dry::Validation.Schema(InsightsEngine::Schemas::Base) do
          required(:languages).value(:hash?)
        end
      end
    end
  end
end
