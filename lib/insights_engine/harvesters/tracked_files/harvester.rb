# frozen_string_literal: true
module InsightsEngine
  module Harvesters
    module TrackedFiles
      class Harvester < Engine::Harvester
        private

        def process
          run "cd #{params.build_path} && git ls-files | wc -l"
        end
      end
    end
  end
end
