# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module Cloc
      class Parser < Engine::Parser
        private

        def process
          languages = []

          (cloc || []).each do |language, data|
            next if language == 'header'

            languages << prepare(language, data)
          end

          { languages: languages }
        end

        def cloc
          @cloc ||= YAML.safe_load(raw[:stdout])
        end

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
