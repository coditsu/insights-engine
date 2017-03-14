# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module RepositoryAuthors
      # Parser for extracting repository authors details out of raw results
      class Parser < Engine::Parser
        # Regexp that matches author name and email from the git shortlog raw
        # output
        MATCH_REGEXP = /\t(.*) <(.*)>/

        private

        # @return [Array<Hash>] array with hashes, where each hash represents
        #   a single author extracted details
        def process
          raw.map do |author_string|
            extract(author_string)
          end
        end

        # Extracts author details from a git shortlog raw string
        # @param author_string [String] raw string with author details
        # @return [Hash] hash with author name and email
        def extract(author_string)
          extracted = author_string.match(MATCH_REGEXP).to_a[1..2]

          {
            name: extracted[0],
            email: extracted[1]
          }
        end
      end
    end
  end
end
