# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitInspector
      class Harvester < Engine::Harvester
        private

        def process
          run "#{encoding} gitinspector.py #{options} #{params.build_path}"
        end

        def encoding
          'PYTHONIOENCODING=utf8'
        end

        def options
          options = []
          options << '--format=json'
          options << "-w -f '**'"
          # Disabled because takes a looot of cpu power to calculate
          # @see https://github.com/ejwa/gitinspector/wiki/Documentation
          # options << '--hard'
          options << '-l -r'
          options.join(' ')
        end
      end
    end
  end
end
