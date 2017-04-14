# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitInspector
      # Parser for extracting git inspector details out of raw results
      class Parser < Engine::Parser
        # Changes statistics key names
        # (under those keys in input hash we have changes related data)
        CHANGES_STATISTICS = %w(
          commits insertions deletions percentage_of_changes
        ).freeze

        # Blame statistics key names
        # (under those keys in input hash we have blame related data)
        BLAME_STATISTICS = %w(
          rows stability age percentage_in_comments
        ).freeze

        private

        # Extracts git inspector data into our internal format
        # @return [Hash] hash with metadata, statistics and responsibilities
        def process
          {
            metadata: build_metadata,
            statistics: build_statistics,
            responsibilities: build_responsibilities
          }
        end

        # @return [Hash] parsed hash with raw gitinspector results
        def git_inspector
          @git_inspector ||= MultiJson.load(raw[:stdout])['gitinspector']
        end

        # Extracts metadata details out of git inspector results
        # @return [Hash] metadata details hash
        def build_metadata
          {
            version: git_inspector['version'],
            repository: git_inspector['repository'],
            report_date: Date.parse(git_inspector['report_date'])
          }
        end

        # Extracts statistics details out of git inspector results
        # @return [Hash] build statistics details hash
        def build_statistics
          authors = build_authors

          map_metrics('changes', authors)
          map_metrics('blame', authors)

          authors.values
        end

        # Extracts responsibilities details out of git inspector results
        # @return [Array<Hash>] Responsibilities of given authors
        def build_responsibilities
          dig('responsibilities').flat_map do |author_data|
            author_data['files'].map do |file|
              {
                email: author_data['email'],
                location: file['name'],
                rows: file['rows']
              }
            end
          end
        end

        # Fetches authors details
        # @return [Hash] hash with authors stats (key corresponds to an author email)
        def build_authors
          authors = {}

          map_authors('changes', authors)
          map_authors('blame', authors)

          authors.each do |_email, author|
            (BLAME_STATISTICS + CHANGES_STATISTICS).each do |metric|
              author[metric.to_sym] = 0
            end
          end

          authors
        end

        # Remaps metrics so they will be complete and will contain valid data
        def map_metrics(key, authors)
          dig(key).each do |author_data|
            email = author_data['email']
            author = authors[email]

            statistic_keys(key).each do |metric|
              author[metric.to_sym] += author_data[metric]
              # Sometimes gitinspector gets crazy and returns values less than 0
              # which should not happen for metrics - that's why we set it to
              # 0 if it goes below
              author[metric.to_sym] = 0 if author[metric.to_sym].negative?
            end
          end
        end

        # Fetches a given keys group out of constants based on the key value
        # @param key [String] blame or statistics
        # @return [Array<String>] key names for a given statistics group
        def statistic_keys(key)
          self.class.const_get("#{key.upcase}_STATISTICS")
        end

        # Maps authors data into our internal symbol key based format
        # @return [Array<Hash>] array with authors statistics details
        def map_authors(key, authors)
          dig(key).each do |author_data|
            email = author_data['email']
            author = (authors[email] ||= {})
            author[:name] = author_data['name']
            author[:email] = author_data['email']
          end
        end

        # Digs to gets author statistics that are under given key
        # @param key [String] 'changes' or 'blame'
        # @return [Array] Array with details
        def dig(key)
          git_inspector.dig(key, 'authors') || []
        end
      end
    end
  end
end
