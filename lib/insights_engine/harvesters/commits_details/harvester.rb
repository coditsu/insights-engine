# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module CommitsDetails
      # Harvester used to get commits details data
      class Harvester < Engine::Harvester
        private

        # @return [Hash] hash with raw result data
        def process
          repo = Rugged::Repository.new(params.build_path)
          walker = Rugged::Walker.new(repo)
          walker.push(repo.last_commit)
          commits = walker.to_a

          shortstat = SupportEngine::Git::Log.shortstat(params.build_path)

          raw(commits: commits, shortstat: shortstat)
        end
      end
    end
  end
end
