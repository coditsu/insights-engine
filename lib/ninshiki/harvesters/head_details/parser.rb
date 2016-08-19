# frozen_string_literal: true
module Ninshiki
  # Namespace for validators
  module Harvesters
    module HeadDetails
      class Parser < Engine::Parser

        def process
          target = raw.dig(:stdout, :target)
          branch = raw.dig(:stdout, :branch)

          {
            id: target.oid,
            message: target.message,
            authored_at: target.author[:time].to_datetime,
            branch: branch,
            author: {
              name: target.author[:name],
              email: target.author[:email]
            }
          }
        end
      end
    end
  end
end
