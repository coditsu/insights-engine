# frozen_string_literal: true
module Ninshiki
  # Namespace for validators
  module Harvesters
    module HeadDetails
      class Harvester < Engine::Harvester
        private

        def process
          repo = Rugged::Repository.new(params.build_path)
          lines_stats = Git.shortstat(params.build_path)

          raw(
            target: repo.head.target,
            lines_stats: lines_stats
          )
        end
      end
    end
  end
end
