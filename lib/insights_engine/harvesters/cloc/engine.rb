# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module Cloc
      class Engine < InsightsEngine::Engine
        self.parser = Cloc::Parser
        self.harvester = Cloc::Harvester
        self.schema = Dry::Validation.Schema(InsightsEngine::Schemas::Base) do
          optional(:languages).each do
            required(:language).filled(:str?)
            required(:files).filled(:int?, gteq?: 0)
            required(:blank).filled(:int?, gteq?: 0)
            required(:comment).filled(:int?, gteq?: 0)
            required(:code).filled(:int?, gteq?: 0)
          end
        end
      end
    end
  end
end
