# frozen_string_literal: true

module InsightsEngine
  module Harvesters
    module RepositorySize
      # Harvester used to get repository size
      class Harvester < Engine::Harvester
        private

        # @return [Hash] hash with raw result data
        def process
          raw(
            codebase_size: run('du -s --exclude .git 2> /dev/null'),
            total_size: run('du -s 2> /dev/null')
          )
        end
      end
    end
  end
end
