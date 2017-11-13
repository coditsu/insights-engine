# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    # Namespace of a RepositorySize harvester
    module RepositorySize
      # Engine for extracting details about the current size of repository (in a current
      # commit context)
      class Engine < InsightsEngine::Engine
        self.parser = RepositorySize::Parser
        self.harvester = RepositorySize::Harvester
        self.schema = Dry::Validation.Schema(InsightsEngine::Schemas::Base) do
          required(:total_size).filled(:int?, gteq?: 0)
          required(:codebase_size).filled(:int?, gteq?: 0)
        end
      end
    end
  end
end
