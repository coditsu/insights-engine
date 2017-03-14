# frozen_string_literal: true
module InsightsEngine
  module Harvesters
    module FilesExtensions
      # Parser for extracting files extensions details out of raw results
      class Parser < Engine::Parser
        # Regexp used to extract details (extension name and number of files with this
        # extension) out of raw row
        EXTRACTING_REGEXP = /^\s*(?<count>\d+)\s+(?<name>.*)/

        private

        # Extracts files extensions details out of raw results
        # @return [Hash] Hash with details on number and amount of files with given extensions
        # @raise [InsightsEngine::Errors::InvalidResponse] raised if there were
        #   any errors in the counting process
        def process
          raise Errors::InvalidResponse unless @raw[:stderr].empty?

          extensions = @raw[:stdout].split("\n").map do |extension|
            match =  extension.match(EXTRACTING_REGEXP)
            { name: match[:name], count: match[:count].to_i }
          end

          { files_extensions: extensions }
        end
      end
    end
  end
end
