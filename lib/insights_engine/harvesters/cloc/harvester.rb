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
          options = []
          options << '--yaml --quiet --progress-rate=0'
          options << params.build_path

          yarn_run('cloc', options.join(' '))
        end
      end
    end
  end
end
