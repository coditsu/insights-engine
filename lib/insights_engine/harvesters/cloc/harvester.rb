# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module Cloc
      class Harvester < Engine::Harvester
        private

        def process
          run "cloc --yaml --quiet --progress-rate=0 #{params.build_path}"
        end
      end
    end
  end
end
