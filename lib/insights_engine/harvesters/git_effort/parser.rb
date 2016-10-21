# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitEffort
      class Parser < Engine::Parser
        CLASSIFIER = /\A\s{2}\e\[\d{2};?\d?m/
        NUMBERS_MATCHER = /.*\s(\d+)\s{2,20}.*\s(\d+)\e\[0m/
        PATH_MATCHER = /(.*)\s\d+\s/
        DOTS_MATCHER = /\.+\Z/

        EFFORTS_LIMIT = 20

        private

        def process
          selected_lines.first(EFFORTS_LIMIT).map do |line|
            line = line.gsub(CLASSIFIER, '')
            location = line.match(PATH_MATCHER).captures.first.gsub(DOTS_MATCHER, '')
            numbers = line.match(NUMBERS_MATCHER).captures
            commits = numbers.first.to_i
            active_days = numbers.last.to_i

            {
              location: location,
              commits: commits,
              active_days: active_days
            }
          end
        end

        def selected_lines
          raw[:stdout].select do |line|
            line =~ CLASSIFIER
          end
        end
      end
    end
  end
end
