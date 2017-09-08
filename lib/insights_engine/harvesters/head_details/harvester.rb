# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module HeadDetails
      # Harvester used to get commit details of a checkouted commit
      class Harvester < Engine::Harvester
        private

        # @return [Hash] hash with raw result data
        def process
          repo = Rugged::Repository.new(params.build_path)
          lines_stats = SupportEngine::Git::Log.shortstat(params.build_path, limit: 1)
          branch = SupportEngine::Git::Branch.commit(params.build_path, repo.head.target.oid)
          diff_hash = SupportEngine::Git::Commits.originated_from(params.build_path, branch, repo.head.target.oid)

          raw(
            target: repo.head.target,
            lines_stats: lines_stats,
            branch: branch,
            diff_hash: diff_hash
          )
        end
      end
    end
  end
end
