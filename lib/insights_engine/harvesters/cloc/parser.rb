# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module Cloc
      # Parser for extracting count lines of code details out of raw results
      class Parser < Engine::Parser
        private

        # Extracts cloc details from raw input
        # @return [Hash] hash with languages distribution
        # @note Due to schema validator, we had to nest hash results
        #   inside of a hash with :languages key
        def process
          languages = []

          (cloc || []).each do |language, data|
            next if language == 'header'

            languages << prepare(language, data)
          end

          { languages: languages }
        end

        # @return [Hash] parsed yaml cloc results
        def cloc
          @cloc ||= YAML.safe_load(raw[:stdout])
        end

        # @param language [String] language for which we have data
        # @param data [Hash] language usage in repo details
        # @return [Hash] hash with all the details about lines of code
        #   of a particular language per lines in repo
        def prepare(language, data)
          {
            language: language,
            files: data['nFiles'],
            blank: data['blank'],
            comment: data['comment'],
            code: data['code']
          }
        end
      end
    end
  end
end
