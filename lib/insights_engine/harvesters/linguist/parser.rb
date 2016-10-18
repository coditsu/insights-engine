# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module Linguist
      class Parser < Engine::Parser
        private

        def process
          result = { languages: raw[:stdout] }
          total_lines = raw[:stdout].values.inject(0){|sum,x| sum + x }
          result[:total_lines] = total_lines

          statistics = {}

          result[:languages].each do |name, lines|
            statistics[name] = ((lines.to_f / total_lines.to_f) * 100).round(4)
          end

          result[:statistics] = statistics.sort_by { |k, v| v }.reverse.to_h

          result
        end
      end
    end
  end
end
