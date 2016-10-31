# frozen_string_literal: true
module InsightsEngine
  module Harvesters
    module TrackedFiles
      class Harvester < Engine::Harvester
        private

        def process
          InsightsEngine::Git.ls_files(params.build_path)
        end
      end
    end
  end
end
