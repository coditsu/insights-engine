# frozen_string_literal: true
module Ninshiki
  # Namespace for validators
  module Harvesters
    module HeadDetails
      class Parser < Engine::Parser

        def process
          result = raw[:stdout]

          {
            id: result.oid,
            message: result.message,
            authored_at: result.author[:time].to_datetime,
            author: {
              name: result.author[:name],
              email: result.author[:email]
            }
          }
        end
      end
    end
  end
end
