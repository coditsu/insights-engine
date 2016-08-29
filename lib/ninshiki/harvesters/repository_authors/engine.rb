# frozen_string_literal: true
module Ninshiki
  # Namespace for validators
  module Harvesters
    module RepositoryAuthors
      class Engine < Ninshiki::Engine
        self.parser = RepositoryAuthors::Parser
        self.harvester = RepositoryAuthors::Harvester
        self.schema = Ninshiki::Schemas::Author
      end
    end
  end
end
