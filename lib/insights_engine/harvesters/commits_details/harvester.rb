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
          shortstat = SupportEngine::Git::Log.shortstat(
            params.build_path,
            since: params.snapshotted_at - 1.day
          )

          repo = Rugged::Repository.new(params.build_path)
          walker = Rugged::Walker.new(repo)
          walker.push(repo.last_commit)
          commits = []

          walker.each do |commit|
            commits << commit
            # We divide by 2, because we get 2 lines of shortstats for each commit
            break if commits.count >= (shortstat.count / 2)
          end

          raw(commits: commits, shortstat: shortstat)
        end
      end
    end
  end
end
