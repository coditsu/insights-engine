# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module Linguist
      class Harvester < Engine::Harvester
        private

        def process
          repo = ::Rugged::Repository.new(params.build_path)

          raw(
            ::Linguist::Repository.new(repo, repo.head.target_id).languages
          )
        end
      end
    end
  end
end
