# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module RepositoryAuthors
      # Harvester used to get details on repository authors
      class Harvester < Engine::Harvester
        private

        # @return [Array<Hash>] array with details of all people that authored
        #   code in a given repo
        # @example
        #   process('/build/path') #=> [{ name: 'Maciej', email: 'maciej@...' }]
        def process
          SupportEngine::Git::Log.shortlog(params.build_path)
        end
      end
    end
  end
end
