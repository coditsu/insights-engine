# frozen_string_literal: true
module Ninshiki
  # Namespace for validators
  module Harvesters
    module CommitsDetails
      class Engine < Ninshiki::Engine
        self.parser = CommitsDetails::Parser
        self.harvester = CommitsDetails::Harvester
        self.schema = Dry::Validation.Schema(Ninshiki::Schemas::Base) do
          required(:id).filled(:str?)
          required(:message).filled(:str?)
          required(:author).filled(Ninshiki::Schemas::Author)
          required(:committer).filled(Ninshiki::Schemas::Author)
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
