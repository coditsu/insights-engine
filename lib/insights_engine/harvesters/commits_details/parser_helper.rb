# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module CommitsDetails
      # Helper for extracting details about commit
      # It contains some methods that use regexp to get details about
      # commit that we're interested in
      module ParserHelper
        # Regexps map for details extraction and matching
        REGEXPS = {
          files_changed: /(\d*) files changed/,
          insertions: /(\d*) insertions/,
          deletions: /(\d*) deletions/
        }.freeze

        # Prepares commit details based on commit data
        # @param commit [Rugged::Commit] rugged commit object
        # @param lines_stats [String] statistics about given lines
        # @return [Hash] hash with commit details
        # @example
        #   prepare(commit, lines_stats).keys #=> [:commit_hash, :message, ...]
        def prepare(commit, lines_stats)
          hash = {}
          hash.merge!(prepare_commit_details(commit))
          hash.merge!(prepare_commit_author(commit))
          hash.merge!(prepare_commit_committer(commit))
          hash.merge!(prepare_lines_stats(lines_stats))
        end

        # Extracts commit details that are stored in rugged object
        # @param commit [Rugged::Commit] rugged commit object
        # @return [Hash] commit details
        def prepare_commit_details(commit)
          {
            commit_hash: commit.oid,
            message: commit.message,
            authored_at: commit.author[:time].to_datetime,
            committed_at: commit.committer[:time].to_datetime
          }
        end

        # Extracts commit author details from rugged commit object
        # @param commit [Rugged::Commit] rugged commit object
        # @return [Hash] commit author details
        def prepare_commit_author(commit)
          {
            author: {
              name: commit.author[:name],
              email: commit.author[:email]
            }
          }
        end

        # Extracts committer details from rugged commit object
        # @param commit [Rugged::Commit] rugged commit object
        # @return [Hash] commit committer details
        def prepare_commit_committer(commit)
          {
            committer: {
              name: commit.committer[:name],
              email: commit.committer[:email]
            }
          }
        end

        # Extracts lines changes statistics from lines_stats string
        # @param lines_stats [String] statistics about given lines
        # @return [Hash] lines changes statistics of a commit
        def prepare_lines_stats(lines_stats)
          {
            files_changed: match_lines_stats(lines_stats, :files_changed),
            insertions: match_lines_stats(lines_stats, :insertions),
            deletions: match_lines_stats(lines_stats, :files_changed)
          }
        end

        # Matches lines_stats against a given regexp key and returns match value
        # @param lines_stats [String] statistics about given lines
        # @return [Integer] extracted regexp key integer value
        def match_lines_stats(lines_stats, regexp_key)
          (lines_stats.match(REGEXPS[regexp_key]) || [])[1].to_i
        end
      end
    end
  end
end
