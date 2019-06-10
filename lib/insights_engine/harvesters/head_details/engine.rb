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
        self.schema = Class.new(InsightsEngine::Schemas::Base) do
          params do
            required(:commit_hash).filled(:str?)
            required(:diff_hash).filled(:str?)
            required(:branch).filled(:str?)
            required(:message) { filled? > str? }
            required(:author).filled(:hash?)
            required(:committer).filled(:hash?)
            required(:authored_at).filled(:date_time?)
            required(:committed_at).filled(:date_time?)
          end

          rule(:author) do
            InsightsEngine::Schemas::Author
              .new
              .call(value)
              .errors
              .each do |error|
                key([:author, error.path[0]]).failure(error.text)
              end
          end

          rule(:committer) do
            InsightsEngine::Schemas::Author
              .new
              .call(value)
              .errors
              .each do |error|
                key([:committer, error.path[0]]).failure(error.text)
              end
          end
        end
      end
    end
  end
end
