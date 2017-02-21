# frozen_string_literal: true
module InsightsEngine
  module Harvesters
    module FilesExtensions
      class Engine < InsightsEngine::Engine
        self.parser = FilesExtensions::Parser
        self.harvester = FilesExtensions::Harvester
        self.schema = Dry::Validation.Schema(InsightsEngine::Schemas::Base) do
          required(:files_extensions).each do
            required(:name).filled(:str?)
            required(:count).filled(:int?, gt?: 0)
          end
        end
      end
    end
  end
end
