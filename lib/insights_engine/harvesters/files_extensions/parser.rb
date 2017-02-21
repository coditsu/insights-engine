# frozen_string_literal: true
module InsightsEngine
  module Harvesters
    module FilesExtensions
      class Parser < Engine::Parser
        EXTRACTING_REGEXP = /^\s*(?<count>\d+)\s+(?<name>.*)/

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
