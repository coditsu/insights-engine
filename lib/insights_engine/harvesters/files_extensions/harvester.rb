# frozen_string_literal: true
module InsightsEngine
  module Harvesters
    module FilesExtensions
      class Harvester < Engine::Harvester
        private

        # @return [Hash] hash with raw result data
        def process
          cmd = []
          cmd << "find #{params.build_path}"
          cmd << '-path ./.git -prune -o -type f' # ignore .git and files only
          cmd << '| sed \'s|.*/|./|\'' # emove dir path from build path
          cmd << '| sed -e \'s/.*\././\'' # Remove paths
          cmd << '| grep -v \'./\'' # Remove files without extensions
          cmd << '| sed -e \'s/.*\///\'' # Remove unnecessary chars
          cmd << '| sed -e \'s/\.//\'' # Remove . from extension
          cmd << '| sort | uniq -c | sort -rn' # sort and count

          run cmd.join(' ')
        end
      end
    end
  end
end
