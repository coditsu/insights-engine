# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module HeadDetails
      # Harvester used to get commit details of a head (current) commit
      class Harvester < Engine::Harvester
        private

        # @return [Hash] hash with raw result data
        def process
          repo = Rugged::Repository.new(params.build_path)
          lines_stats = SupportEngine::Git::Log.shortstat(params.build_path, limit: 1)
          branch = SupportEngine::Git::Branch.head(params.build_path)

          raw(
            target: repo.head.target,
            lines_stats: lines_stats,
            branch: branch
          )
        end
      end
    end
  end
end
