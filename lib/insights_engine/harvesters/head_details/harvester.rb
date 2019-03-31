# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module HeadDetails
      # Harvester used to get commit details of an analyzed commit
      class Harvester < Engine::Harvester
        private

        # @return [Hash] hash with raw result data
        def process
          repo = Rugged::Repository.new(params.build_path)

          lines_stats = SupportEngine::Git::Log.shortstat(
            params.build_path,
            limit: 1
          )

          branch = SupportEngine::Git::Branch.commit(
            params.build_path,
            repo.head.target.oid
          )

          diff_hash = SupportEngine::Git::Branch.originated_from(
            params.build_path,
            branch,
            params.default_branch
          )

          format_raw(repo, lines_stats, branch, diff_hash)
        end

        # Extracts required data and combines it into a raw result
        # @return [Hash] hash with raw data
        # @param repo [Rugged::Repository] rugged repository instance
        # @param lines_stats [Array<String>] line changes statistics
        # @param branch [String] branch name
        # @param diff_hash [String] diff commit hash
        def format_raw(repo, lines_stats, branch, diff_hash)
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
