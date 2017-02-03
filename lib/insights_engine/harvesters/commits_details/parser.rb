# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module CommitsDetails
      class Parser < Engine::Parser
        include ParserHelper

        def process
          commits = raw.dig(:stdout, :commits)
          shortstat = raw.dig(:stdout, :shortstat)

          results = []

          commits.each do |commit|
            lines_stats = seek(shortstat, commit.oid)
            results << prepare(commit, lines_stats)
          end

          results
        end

        private

        def seek(log_details, commit)
          current_line = 0

          log_details.each_with_index do |detail, line|
            current_line = line
            return log_details[line + 1] if detail.start_with? commit
          end

          raise Errors::UnmatchedCommit, commit
        end
      end
    end
  end
end
