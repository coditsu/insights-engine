# frozen_string_literal: true

module InsightsEngine
  module Harvesters
    module TrackedFiles
      # Harvester used to get details about number of tracked files in a give repository
      #   on a given commit revision
      class Harvester < Engine::Harvester
        private

        # @return [Array<String>] array with unparsed stringified number of tracked files
        def process
          InsightsEngine::Git.ls_files(params.build_path)
        end
      end
    end
  end
end
