# frozen_string_literal: true
module Ninshiki
  # Namespace for validators
  module Harvesters
    module HeadDetails
      class Harvester < Engine::Harvester
        private

        def process
          repo = Rugged::Repository.new(params.build_path)
          branch = run("cd #{params.build_path} && git name-rev --name-only HEAD")[:stdout]
          raw(
            target: repo.head.target,
            branch: branch
          )
        end
      end
    end
  end
end
