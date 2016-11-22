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

            languages << {
              language: language,
              files: data['nFiles'],
              blank: data['blank'],
              comment: data['comment'],
              code: data['code']
            }
          end

          { languages: languages }
        end

        def cloc
          @cloc ||= YAML.load(raw[:stdout])
        end
      end
    end
  end
end
