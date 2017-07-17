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
          # We take shortstats for 2 days earlier than the most recent commit just to be
          # sure that we don't omit any commits
          repo = Rugged::Repository.new(params.build_path)
          # We need to find last day with a commit and use this + offset to fetch
          # data. We can't use snapshotted_at, because there might not be any commits and
          # data for a given timeframe
          since = repo.last_commit.time - 2.days
          shortstat_data = shortstat(since)

          raw(
            # We divide by 2, because we get 2 lines of shortstats for each commit
            commits: commits(repo, shortstat_data.count / 2),
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

        # @param repo [Rugged::Repository] handler to rugged repo object
        # @param amount [Integer] how many commits (desc order) we want
        # @note This needs to match the number from other commands so we have
        #   exactly the same amount of details on all the commits that we fetch
        # @return [Array<Rugged::Commit>] rugged commits details
        def commits(repo, amount)
          commits = []

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
