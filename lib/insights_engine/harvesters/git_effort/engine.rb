# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitEffort
      class Engine < InsightsEngine::Engine
        self.parser = GitEffort::Parser
        self.harvester = GitEffort::Harvester
        self.schema = Dry::Validation.Schema(InsightsEngine::Schemas::Base) do
          required(:path).filled(:str?)
          required(:commits_count).filled(:int?, gteq?: 10)
          required(:active_days_count).filled(:int?, gt?: 0)
        end
      end
    end
  end
end
