# frozen_string_literal: true
module Ninshiki
  # Namespace for validators
  module Harvesters
    module HeadDetails
      class Harvester < Engine::Harvester
        private

        def process
          repo = Rugged::Repository.new(params.build_path)
          raw(repo.head.target)
        end
      end
    end
  end
end
