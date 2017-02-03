# frozen_string_literal: true
module InsightsEngine
  class Engine
    # Parser base class
    # Parsers are used to parse the validator output into a "workable" format
    # for example from JSON into a Ruby hash
    class Parser
      # @param raw [Hash] hash with raw validator results output
      # @return [Hash] hash with data based on which we will build final results
      def call(raw)
        @raw = raw
        process
      end

      private

      attr_reader :raw

      # This method needs to be implemented in a subclass
      # @raise [InsightsEngine::Errors::ImplementationMissing]
      def process
        raise InsightsEngine::Errors::ImplementationMissing
      end
    end
  end
end
