# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    # Namespace of a Authors harvester
    module Authors
      # Engine for extracting details about all the repository authors (that is people
      # that committed changed, etc)
      class Engine < InsightsEngine::Engine
        self.parser = Authors::Parser
        self.harvester = Authors::Harvester
        self.schema = InsightsEngine::Schemas::Author
      end
    end
  end
end
