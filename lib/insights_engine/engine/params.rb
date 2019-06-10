# frozen_string_literal: true

module InsightsEngine
  class Engine
    # OpenStruct object that holds parameters of a given validation process
    class Params < OpenStruct
      # Schema for ensuring proper params structure
      SCHEMA = Schemas::Params.new.freeze

      private_constant :SCHEMA

      # @param args [Array] arguments that should match params schema
      #   requirements
      def initialize(*args)
        SCHEMA.call(*args)
        super
      end
    end
  end
end
