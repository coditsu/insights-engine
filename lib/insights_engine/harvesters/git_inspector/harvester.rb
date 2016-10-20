# frozen_string_literal: true
module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitInspector
      class Harvester < Engine::Harvester
        private

        def process
          encoding = 'PYTHONIOENCODING=utf8'
          options = []
          options << '--format=json'
          options << '-w -f \'**\''
          options << '--hard'
          options << '-l -r'

          Shell.call "#{encoding} gitinspector.py #{options.join(' ')} #{params.build_path}"
        end
      end
    end
  end
end
