# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module HeadDetails
      # Helper for extracting details about commit
      # It contains some methods that use regexp to get details about
      # commit that we're interested in
      module ParserHelper
        # Regex map for details extraction and matching
        REGEXPS = {
          files_changed: /(\d*) file.? changed/,
          insertions: /(\d*) insertion.?/,
          deletions: /(\d*) deletion.?/
        }.freeze

        # Prepares commit details based on commit data
        # @param commit [Rugged::Commit] rugged commit object
        # @return [Hash] hash with commit details
        # @example
        #   prepare(commit).keys #=> [:commit_hash, :message, ...]
        def prepare(commit)
          hash = {}
          hash.merge!(prepare_commit_details(commit))
          hash.merge!(prepare_commit_author(commit))
          hash.merge!(prepare_commit_committer(commit))
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

        # Matches lines_stats against a given regexp key and returns match value
        # @param lines_stats [String] statistics about given lines
        # @param regexp_key [Regexp] regexp we want to use to match this line stats
        # @return [Integer] extracted regexp key integer value
        def match_lines_stats(lines_stats, regexp_key)
          (lines_stats.match(REGEXPS[regexp_key]) || [])[1].to_i
        end
      end
    end
  end
end
