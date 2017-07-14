# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module CommitsDetails
      # Harvester used to get commits details data about the snapshotted day and the previous one
      class Harvester < Engine::Harvester
        private

        # @return [Hash] hash with raw result data
        def process
          # We take shortstats for 1 day earlier just not to care about timezones
          # etc. Way more convenient
          since = params.snapshotted_at - 1.day

          shortstat_data = shortstat(since)

          raw(
            # We divide by 2, because we get 2 lines of shortstats for each commit
            commits: commits(shortstat_data.count / 2),
            shortstat: shortstat_data,
            branches: branches(since)
          )
        end

        # @param [Date] since when we want to get shortstat
        # @return [Array<String>] array with non parsed shortstat lines
        def shortstat(since)
          SupportEngine::Git::Log.shortstat(
            params.build_path,
            since: since
          )
        end

        # @param amount [Integer] how many commits (desc order) we want
        # @note This needs to match the number from other commands so we have
        #   exactly the same amount of details on all the commits that we fetch
        # @return [Array<Rugged::Commit>] rugged commits details
        def commits(amount)
          commits = []

          repo = Rugged::Repository.new(params.build_path)
          walker = Rugged::Walker.new(repo)
          walker.push(repo.last_commit)

          walker.each do |commit|
            break if commits.count >= amount
            commits << commit
          end

          commits
        end

        # @param [Date] since when we want to get shortstat
        # @return [Array<Hash>] array with hashes that contain commit details including branch
        def branches(since)
          SupportEngine::Git::Commits.all(
            params.build_path,
            since: since
          )
        end
      end
    end
  end
end
