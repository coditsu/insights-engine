# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module Cloc
      # Harvester used to gather lines of code details using cloc
      class Harvester < Engine::Harvester
        private

        # @return [Hash] hash with raw result data
        def process
          run "cloc --yaml --quiet --progress-rate=0 #{params.build_path}"
        end
      end
    end
  end
end
