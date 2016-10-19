# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitEffort
      class Parser < Engine::Parser
        CLASSIFIER = /\A\s{2}\e\[\d{2};?\d?m/
        NUMBERS_MATCHER = /.*\s(\d+)\s{8}.*\s(\d+)\e\[0m/
        PATH_MATCHER = /(.*)\s\d+\s/
        DOTS_MATCHER = /\.+\Z/

        private

        def process
          selected_lines.map do |line|
            line = line.gsub(CLASSIFIER, '')
            location = line.match(PATH_MATCHER).captures.first.gsub(DOTS_MATCHER, '')
            numbers = line.match(NUMBERS_MATCHER).captures
            commits_count = numbers.first.to_i
            active_days_count = numbers.last.to_i

            {
              location: location,
              commits_count: commits_count,
              active_days_count: active_days_count
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
