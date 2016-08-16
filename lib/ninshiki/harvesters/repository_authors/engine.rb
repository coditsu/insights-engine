# frozen_string_literal: true
module Ninshiki
  # Namespace for validators
  module Harvesters
    module RepositoryAuthors
      class Engine < Ninshiki::Engine
        self.parser = RepositoryAuthors::Parser
        self.harvester = RepositoryAuthors::Harvester
        self.schema = Dry::Validation.Schema(Ninshiki::Schemas::Base) do
          required(:name).filled(:str?)
          required(:email).filled(:str?)
        end
      end
    end
  end
end
