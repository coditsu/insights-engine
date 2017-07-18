# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    # Namespace of a CommitsDetails harvester
    module CommitsDetails
      # Engine for gathring details about all the commits in repository
      class Engine < InsightsEngine::Engine
        self.parser = CommitsDetails::Parser
        self.harvester = CommitsDetails::Harvester
        # Schema for final results format validation
        self.schema = Dry::Validation.Schema(InsightsEngine::Schemas::Base) do
          # There's an option to add a commit without a message by doing like so:
          # git commit  -a --allow-empty-message -m '' that's why we don't require
          # it to be filled
          required(:message)
          required(:commit_hash).filled(:str?)
          required(:author).filled(InsightsEngine::Schemas::Author)
          required(:committer).filled(InsightsEngine::Schemas::Author)
          required(:authored_at).filled(:date_time?)
          required(:committed_at).filled(:date_time?)
          required(:files_changed).filled(:int?, gteq?: 0)
          required(:insertions).filled(:int?, gteq?: 0)
          required(:deletions).filled(:int?, gteq?: 0)
        end
      end
    end
  end
end
