# frozen_string_literal: true
module Ninshiki
  # Namespace for validators
  module Harvesters
    module RepositoryAuthors
      class Parser < Engine::Parser
        # Regexp that matches author name and email from the git shortlog raw output
        MATCH_REGEXP = /\t(.*) <(.*)>/

        def process
          raw.map do |author_string|
            extract(author_string)
          end
        end

        private

        # @param build_path [String] path of a current repository build
        # @return [Array<String>] unformatted raw data from git shortlog
        # @example
        #   authors('/build/path') #=> ["    20\tMaciej Mensfeld <maciej@mensfeld.pl>"]
        def authors(build_path)
          Ninshiki::Git.shortlog(build_path)
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
