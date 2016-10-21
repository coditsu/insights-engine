# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitInspector
      class Engine < InsightsEngine::Engine
        self.parser = GitInspector::Parser
        self.harvester = GitInspector::Harvester
        self.schema = Dry::Validation.Schema(InsightsEngine::Schemas::Base) do
          required(:metadata).schema do
            required(:version).filled
            required(:repository).filled
            required(:report_date).filled(:date?)
          end

          required(:extensions).each(:str?)

          required(:statistics).each do
            required(:name)
            required(:email).filled(:str?)
            required(:commits).value(gteq?: 0)
            required(:insertions).value(gteq?: 0)
            required(:deletions).value(gteq?: 0)
            required(:percentage_of_changes).value(gteq?: 0, lteq?: 100)
          end

          required(:responsibilities).each do
            required(:email).filled(:str?)
            required(:location).filled(:str?)
            required(:rows).value(gteq?: 0)
          end
        end
      end
    end
  end
end
