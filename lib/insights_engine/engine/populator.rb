# frozen_string_literal: true

module InsightsEngine
  class Engine
    # Base populator from which all other populators should inherit
    # Populators are used to populate the buffer structure with data
    # @note Populators operate directly on the engine buffer object
    class Populator
      # Each populator should use a fetcher to drain the data either from git or
      # any other place
      class_attribute :fetcher

      # @param params [InsightsEngine::Engine::Params] build process params
      #   details
      # @param buffer [InsightsEngine::Engine::Buffer] engine's buffer
      def call(params, buffer)
        @params = params
        @buffer = buffer
        process
      end

      private

      attr_reader :params
      attr_reader :buffer

      # This method needs to be implemented in a subclass
      # @raise [InsightsEngine::Errors::ImplementationMissing]
      def process
        raise InsightsEngine::Errors::ImplementationMissing
      end

      # @return [Ejin::Engine::Fetcher] populator fetcher instance
      def fetcher
        self.class.fetcher.new
      end
    end
  end
end
