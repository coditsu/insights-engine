# frozen_string_literal: true
module Ninshiki
  # Namespace for validators
  module Harvesters
    module HeadDetails
      class Engine < Ninshiki::Engine
        self.parser = HeadDetails::Parser
        self.harvester = HeadDetails::Harvester
        self.schema = Dry::Validation.Schema(Ninshiki::Schemas::Base) do
          required(:id).filled(:str?)
          required(:message).filled(:str?)
          required(:branch).filled(:str?)
          required(:author).filled(Ninshiki::Schemas::Author)
          required(:authored_at).filled(:date_time?)
        end
      end
    end
  end
end
