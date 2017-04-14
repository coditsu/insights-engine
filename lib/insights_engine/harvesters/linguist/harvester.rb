# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module Linguist
      # Harvester used to get linguist languages distribution raw data
      class Harvester < Engine::Harvester
        private

        # @return [Hash] hash with raw result data
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
