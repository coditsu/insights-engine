# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    # Namespace of a RepositoryAuthors harvester
    module RepositoryAuthors
      # Engine for extracting details about all the repository authors (that is people
      # that committed changed, etc)
      class Engine < InsightsEngine::Engine
        self.parser = RepositoryAuthors::Parser
        self.harvester = RepositoryAuthors::Harvester
        self.schema = InsightsEngine::Schemas::Author
      end
    end
  end
end
