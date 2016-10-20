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
            metadata: build_metadata,
            statistics: build_statistics,
            responsibilities: build_responsibilities
          }
        end

        def git_inspector
          @git_inspector ||= MultiJson.load(raw[:stdout])['gitinspector']
        end

        def build_metadata
          {
            version: git_inspector['version'],
            repository: git_inspector['repository'],
            report_date: Date.parse(git_inspector['report_date']),
            extensions: git_inspector['extensions']['used']
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
            author[:occurences] ||= 0
            author[:occurences] += 1

            BLAME_STATISTICS.each do |metric|
              author[metric.to_sym] = author_data[metric]
            end
          end

          authors.values
        end

        def build_responsibilities
          responsibilities = {}

          git_inspector.dig('responsibilities', 'authors').each do |author_data|
            email = author_data['email']
            respo = responsibilities[email] = {}
            respo[:occurences] ||= 0
            respo[:occurences] += 1
            respo[:email] = email
            respo[:files] = []

            author_data['files'].each do |file|
              respo[:files] << {
                location: file['name'],
                rows: file['rows']
              }
            end
          end

          responsibilities.values
        end
      end
    end
  end
end
