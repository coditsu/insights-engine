# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module CommitsDetails
      # Parser for extracting commits details out of raw results
      class Parser < Engine::Parser
        include ParserHelper

        private

        # Parser raw data and converts it into our internal format
        # @return [Array<Hash>] Array with hashes that (each of them)
        #   contain details about each commit from repository
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

        # Seeks in raw git log stuff details on a given commit
        # @param log_details [Array<String>] git log results splitted by new line
        # @param commit [String] id of a commit
        # @raise [InsightsEngine::Errors::UnmatchedCommit] raised when we could not match
        #   commit with any data (should never happen)
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
