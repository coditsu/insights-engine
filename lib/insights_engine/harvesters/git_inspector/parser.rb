# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitInspector
      class Parser < Engine::Parser
        private

        CHANGES_STATISTICS = %w(
          commits insertions deletions percentage_of_changes
        )

        BLAME_STATISTICS = %w(
          rows stability age percentage_in_comments
        )

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
          git_inspector['extensions']['used']
        end

        def build_metadata
          {
            version: git_inspector['version'],
            repository: git_inspector['repository'],
            report_date: Date.parse(git_inspector['report_date'])
          }
        end

        def build_statistics
          authors = {}

          git_inspector.dig('changes', 'authors').each do |author_data|
            email = author_data['email']
            author = (authors[email] ||= {})
            author[:name] = author_data['name']
            author[:email] = author_data['email']

            CHANGES_STATISTICS.each do |metric|
              author[metric.to_sym] ||= 0
              author[metric.to_sym] += author_data[metric]
            end
          end

          git_inspector.dig('blame', 'authors').each do |author_data|
            email = author_data['email']
            author = authors[email]

            BLAME_STATISTICS.each do |metric|
              author[metric.to_sym] = author_data[metric]
            end
          end

          authors.values
        end

        def build_responsibilities
          git_inspector.dig('responsibilities', 'authors').flat_map do |author_data|
            email = author_data['email']

            author_data['files'].map do |file|
              {
                email: email,
                location: file['name'],
                rows: file['rows']
              }
            end
          end
        end
      end
    end
  end
end
