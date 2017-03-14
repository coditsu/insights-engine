# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module CommitsDetails
      # Parser for extracting commits details out of raw results
      class Parser < Engine::Parser
        include ParserHelper

        private

        def process
          commits = raw.dig(:stdout, :commits)
          shortstat = raw.dig(:stdout, :shortstat)

          results = []

          commits.each do |commit|
            lines_stats = seek(shortstat, commit.oid)
            # This can be nil on the last log_details line (that is empty)
            results << prepare(commit, lines_stats) if lines_stats
          end

          results
        end

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
