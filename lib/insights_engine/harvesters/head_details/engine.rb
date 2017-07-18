# frozen_string_literal: true

module InsightsEngine
  # Namespace for validators
  module Harvesters
    # Namespace of a HeadDetails harvester
    module HeadDetails
      # Engine that extracts head commit details of a given repository
      class Engine < InsightsEngine::Engine
        self.parser = HeadDetails::Parser
        self.harvester = HeadDetails::Harvester
        # Schema for final results format validation
        self.schema = Dry::Validation.Schema(InsightsEngine::Schemas::Base) do
          required(:commit_hash).filled(:str?)
          required(:branch).filled(:str?)
          required(:message) { filled? > str? }
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
