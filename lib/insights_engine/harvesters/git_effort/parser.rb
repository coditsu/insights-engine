# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitEffort
      # Parser for extracting git effort details out of raw results
      class Parser < Engine::Parser
        NUMBERS_MATCHER = /.*\s(\d+)\s{2,20}.*\s(\d+)/
        PATH_MATCHER = /(.*)\s\d+\s/
        DOTS_MATCHER = /\.+\Z/

        EFFORTS_LIMIT = 20

        private

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

        def selected_lines
          raw[:stdout].select do |line|
            line =~ PATH_MATCHER
          end
        end

        def location_from_line(line)
          line.match(PATH_MATCHER).captures.first.gsub(DOTS_MATCHER, '').strip
        end

        def numbers_from_line(line)
          line.match(NUMBERS_MATCHER).captures
        end
      end
    end
  end
end
