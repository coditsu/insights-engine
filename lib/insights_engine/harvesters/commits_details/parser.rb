# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module CommitsDetails
      class Parser < Engine::Parser
        REGEXPS = {
          files_changed: /(\d*) files changed/,
          insertions: /(\d*) insertions/,
          deletions: /(\d*) deletions/
        }.freeze

        def process
          commits = raw.dig(:stdout, :commits)
          shortstat = raw.dig(:stdout, :shortstat)

          results = []

          commits.each do |commit|
            lines_stats = seek(shortstat, commit.oid)

            results << {
              commit_hash: commit.oid,
              message: commit.message,
              authored_at: commit.author[:time].to_datetime,
              committed_at: commit.committer[:time].to_datetime,
              author: {
                name: commit.author[:name],
                email: commit.author[:email]
              },
              committer: {
                name: commit.committer[:name],
                email: commit.committer[:email]
              },
              files_changed: (lines_stats.match(REGEXPS[:files_changed]) || [])[1].to_i,
              insertions: (lines_stats.match(REGEXPS[:insertions]) || [])[1].to_i,
              deletions: (lines_stats.match(REGEXPS[:deletions]) || [])[1].to_i
            }
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
