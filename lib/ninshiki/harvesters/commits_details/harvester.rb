# frozen_string_literal: true
module Ninshiki
  # Namespace for validators
  module Harvesters
    module CommitsDetails
      class Harvester < Engine::Harvester
        private

        def process
          repo = Rugged::Repository.new(params.build_path)
          walker = Rugged::Walker.new(repo)
          walker.push(repo.last_commit)
          commits = walker.to_a
          shortstat = Git.shortstat(params.build_path)

          raw({
            commits: commits,
            shortstat: shortstat
          })
        end
      end
    end
  end
end
