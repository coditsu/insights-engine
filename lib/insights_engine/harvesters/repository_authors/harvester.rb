# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module RepositoryAuthors
      class Harvester < Engine::Harvester
        # Regexp that matches author name and email from the git shortlog raw output
        MATCH_REGEXP = /\t(.*) <(.*)>/

        private

        # @param build_path [String] path of a current repository build
        # @return [Array<Hash>] array with details of all people that authored code in a given repo
        # @example
        #   process('/build/path') #=> [{ name: 'Maciej', email: 'maciej@...' }]
        def process
          InsightsEngine::Git.shortlog(params.build_path)
        end
      end
    end
  end
end
