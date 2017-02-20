# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitInspector
      class Parser < Engine::Parser
        private

        CHANGES_STATISTICS = %w(
          commits insertions deletions percentage_of_changes
        ).freeze

        BLAME_STATISTICS = %w(
          rows stability age percentage_in_comments
        ).freeze

        def process
          {
            extensions: build_extensions,
            metadata: build_metadata,
            statistics: build_statistics,
            responsibilities: build_responsibilities
          }
        end

        def git_inspector
          @git_inspector ||= MultiJson.load(raw[:stdout])['gitinspector']
        end

        def build_extensions
          return [] unless git_inspector['extensions']
          return [] unless git_inspector['extensions']['used']

          git_inspector['extensions']['used'] - ['*']
        end

        def build_metadata
          {
            version: git_inspector['version'],
            repository: git_inspector['repository'],
            report_date: Date.parse(git_inspector['report_date'])
          }
        end

        def build_statistics
          authors = build_authors

          map_metrics('changes', authors)
          map_metrics('blame', authors)

          authors.values
        end

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

        def statistic_keys(key)
          self.class.const_get("#{key.upcase}_STATISTICS")
        end

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

        def map_authors(key, authors)
          dig(key).each do |author_data|
            email = author_data['email']
            author = (authors[email] ||= {})
            author[:name] = author_data['name']
            author[:email] = author_data['email']
          end
        end

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

        def dig(key)
          git_inspector.dig(key, 'authors') || []
        end
      end
    end
  end
end
