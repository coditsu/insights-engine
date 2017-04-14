# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    # Namespace of a GitEffort harvester
    module GitEffort
      # GitEffort engine
      # @see https://github.com/tj/git-extras
      class Engine < InsightsEngine::Engine
        self.parser = GitEffort::Parser
        self.harvester = GitEffort::Harvester
        # Schema for final results format validation
        self.schema = Dry::Validation.Schema(InsightsEngine::Schemas::Base) do
          required(:location).filled(:str?)
          required(:commits).filled(:int?, gteq?: 2)
          required(:active_days).filled(:int?, gt?: 0)
        end
      end
    end
  end
end
