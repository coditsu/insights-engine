# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitInspector
      class Harvester < Engine::Harvester
        THRESHOLD = 1.month

        private

        # @return [Hash] hash with raw result data
        def process
          run "#{encoding} gitinspector.py #{options(params)} #{params.build_path}"
        end

        def encoding
          'PYTHONIOENCODING=utf8'
        end

        def options(params)
          head_committed_at = Git.head_committed_at(params.build_path)

          options = []
          options << '--format=json'
          options << "-w -f '**'"
          # Disabled because takes a looot of cpu power to calculate
          # @see https://github.com/ejwa/gitinspector/wiki/Documentation
          # options << '--hard'
          options << '-l -r'
          options << "--since=\"#{head_committed_at - THRESHOLD}\""
          options.join(' ')
        end
      end
    end
  end
end
