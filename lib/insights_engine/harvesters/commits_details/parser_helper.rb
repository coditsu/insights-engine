# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module CommitsDetails
      module ParserHelper
        REGEXPS = {
          files_changed: /(\d*) files changed/,
          insertions: /(\d*) insertions/,
          deletions: /(\d*) deletions/
        }.freeze

        def prepare(commit, lines_stats)
          hash = {}
          hash.merge!(prepare_commit_details(commit))
          hash.merge!(prepare_commit_author(commit))
          hash.merge!(prepare_commit_committer(commit))
          hash.merge!(prepare_lines_stats(lines_stats))
        end

        def prepare_commit_details(commit)
          {
            commit_hash: commit.oid,
            message: commit.message,
            authored_at: commit.author[:time].to_datetime,
            committed_at: commit.committer[:time].to_datetime
          }
        end

        def prepare_commit_author(commit)
          {
            author: {
              name: commit.author[:name],
              email: commit.author[:email]
            }
          }
        end

        def prepare_commit_committer(commit)
          {
            committer: {
              name: commit.committer[:name],
              email: commit.committer[:email]
            }
          }
        end

        def prepare_lines_stats(lines_stats)
          {
            files_changed: match_lines_stats(lines_stats, :files_changed),
            insertions: match_lines_stats(lines_stats, :insertions),
            deletions: match_lines_stats(lines_stats, :files_changed)
          }
        end

        def match_lines_stats(lines_stats, key)
          (lines_stats.match(REGEXPS[key]) || [])[1].to_i
        end
      end
    end
  end
end
