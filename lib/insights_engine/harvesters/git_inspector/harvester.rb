# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    module GitInspector
      # Harvester used to execute and get raw results from git inspector
      class Harvester < Engine::Harvester
        # How long back do we analyze
        # Analyzing whole history takes a lot of time and cpu power and
        # returned data is accurate in terms of overall details but it does not
        # reflect short period changes (especially for new authors), so we
        # always dig 1 month back from the snapshot date
        THRESHOLD = 1.month

        private

        # @return [Hash] hash with raw result data
        def process
          run "#{encoding} gitinspector.py #{options(params)} #{params.build_path}"
        end

        # @return [String] default encoding for gitinspector
        def encoding
          'PYTHONIOENCODING=utf8'
        end

        # Builds a gitinspector shell command parameters string
        # @param params [InsightsEngine::Engine::Params] build process
        #   params details
        # @return [String] git inspector shell params
        def options(params)
          options = []
          options << '--format=json'
          options << "-w -f '**'"
          options << '-l -r'
          options << "--since=\"#{params.snapshotted_at - THRESHOLD}\""
          options << "--until=\"#{params.snapshotted_at + 1.day}\""
          options.join(' ')
        end
      end
    end
  end
end
