# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitEffort
      # Parser for extracting git effort details out of raw results
      class Parser < Engine::Parser
        # Regexp to match line with number of efforts (there might be lines that
        # we consider a noise)
        NUMBERS_MATCHER = /.*\s(\d+)\s{2,20}.*\s(\d+)/
        # Regexp used to match line with file path
        PATH_MATCHER = /(.*)\s\d+\s/
        # Regexp to remove unnecessary characters from file paths
        DOTS_MATCHER = /\.+\Z/

        # Number of top (since efforts are sorted)
        EFFORTS_LIMIT = 20

        private

        # Gets raw efforst data and parses it into our internal format
        # @return [Array<Hash>] array with top efforts and their details
        def process
          selected_lines.first(EFFORTS_LIMIT).map do |line|
            commits, active_days = numbers_from_line(line)

            {
              location: location_from_line(line),
              commits: commits.to_i,
              active_days: active_days.to_i
            }
          end
        end

        # The raw git effort contains noise lines that we remove by selecting
        # only lines that match our regexp
        # @return [Array<String>] lines with effort details (without noise)
        def selected_lines
          raw[:stdout].select do |line|
            line =~ PATH_MATCHER
          end
        end

        # Extracts file path from an effort line
        # @param [String] single effort line
        # @return [String] extracted file path from an effort line
        # @example
        #   location_from_line('  tables.scss. 10          6') #=> 'tables.scss'
        def location_from_line(line)
          line.match(PATH_MATCHER).captures.first.gsub(DOTS_MATCHER, '').strip
        end

        # @param [String] single effort line
        # @return [Array<String>] matched effort numbers
        # @example
        #   numbers_from_line('  tables.scss. 10          6') #=> ['10', '6']
        def numbers_from_line(line)
          line.match(NUMBERS_MATCHER).captures
        end
      end
    end
  end
end
