# frozen_string_literal: true

module InsightsEngine
  class Engine
    # OpenStruct object that holds parameters of a given validation process
    class Params < OpenStruct
      # @param args [Array] arguments that should match params schema
      #   requirements
      def initialize(*args)
        super Schemas::Params.call(*args).output
      end
    end
  end
end
