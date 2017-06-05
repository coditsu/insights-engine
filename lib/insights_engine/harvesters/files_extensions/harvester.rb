# frozen_string_literal: true

module InsightsEngine
  module Harvesters
    module FilesExtensions
      # Harvester used to get files extensions count
      class Harvester < Engine::Harvester
        private

        # @return [Hash] hash with raw result data
        def process
          cmd = []
          cmd << "find #{params.build_path}"
          # ignore .git folder
          cmd << "-not \\( -path '#{File.join(params.build_path, '.git')}' -prune \\) -type f"
          # remove dir path from build path
          cmd << '| sed \'s|.*/|./|\''
          # remove paths
          cmd << '| sed -e \'s/.*\././\''
          # remove files without extensions
          cmd << '| grep -v \'./\''
          # remove unnecessary chars
          cmd << '| sed -e \'s/.*\///\''
          # remove . from extension
          cmd << '| sed -e \'s/\.//\''
          # sort and count
          cmd << '| sort | uniq -c | sort -rn'

          run cmd.join(' ')
        end
      end
    end
  end
end
