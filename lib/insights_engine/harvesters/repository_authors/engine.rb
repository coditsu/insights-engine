# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module RepositoryAuthors
      class Engine < InsightsEngine::Engine
        self.parser = RepositoryAuthors::Parser
        self.harvester = RepositoryAuthors::Harvester
        self.schema = InsightsEngine::Schemas::Author
      end
    end
  end
end
