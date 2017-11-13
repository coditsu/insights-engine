# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module RepositorySize
      # Parser for extracting repository size details out of raw results
      class Parser < Engine::Parser
        private

        # @return [Hash] hash with both codebase size and total size (with git dir)
        def process
          {
            total_size: raw.dig(:stdout, :total_size, :stdout).to_i,
            codebase_size: raw.dig(:stdout, :codebase_size, :stdout).to_i
          }
        end
      end
    end
  end
end
