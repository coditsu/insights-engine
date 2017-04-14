# frozen_string_literal: true

module InsightsEngine
  module Harvesters
    # Namespace of a FilesExtensions harvester
    module FilesExtensions
      # Engine that tracks files extensions and number of files with given extensions
      class Engine < InsightsEngine::Engine
        self.parser = FilesExtensions::Parser
        self.harvester = FilesExtensions::Harvester
        # Schema for final results format validation
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
