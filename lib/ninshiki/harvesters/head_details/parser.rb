# frozen_string_literal: true
module Ninshiki
  # Namespace for validators
  module Harvesters
    module HeadDetails
      class Parser < Engine::Parser
        REGEXPS = {
          files_changed: /(\d*) files changed/,
          insertions: /(\d*) insertions/,
          deletions: /(\d*) deletions/
        }

        def process
          target = raw.dig(:stdout, :target)

          lines_stats = raw.dig(:stdout, :lines_stats).last

          {
            id: target.oid,
            message: target.message,
            authored_at: target.author[:time].to_datetime,
            author: {
              name: target.author[:name],
              email: target.author[:email]
            },
            files_changed: (lines_stats.match(REGEXPS[:files_changed]) || [])[1].to_i,
            insertions: (lines_stats.match(REGEXPS[:insertions]) || [])[1].to_i,
            deletions: (lines_stats.match(REGEXPS[:deletions]) || [])[1].to_i
          }
        end
      end
    end
  end
end
