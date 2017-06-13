# frozen_string_literal: true

module InsightsEngine
  # Engine base class for other engines
  # Each engine is consisted from following parts:
  #   - validator - core part that performs analysis
  #   - parser - class responsible for parsing results into a format easier to
  #     work with (for example from string into YARD)
  #   - populators - array that should consist populators classes
  #
  # @note Each engine needs to implement all the attributes
  #   (even if they just inherit)
  # @note Final result of the validation needs to be valid with
  #   InsightsEngine::Schemas::Result validation schema and if no exceptions are
  #   raised, it means that it will work with other parts of the Coditsu
  #   software
  # @note Note that you don't define any methods on the engine directly
  #
  # @example Example engine
  #   class Engine < InsightsEngine::Engine
  #     self.parser = ExampleEngine::Parser
  #     self.validator = ExampleEngine::Validator
  #     self.populators = [
  #       ExampleEngine::Populators::Metadata,
  #       ExampleEngine::Populators::Offenses,
  #       ExampleEngine::Populators::Authors,
  #       ExampleEngine::Populators::Lines,
  #       ExampleEngine::Populators::LinesAuthors
  #     ]
  #   end
  class Engine
    class_attribute :harvester
    # Validator class must inherit from InsightsEngine::Engine::Parser
    class_attribute :parser
    # Schema that should be used to validate output of a given harvester
    class_attribute :schema

    # Input parameters that are provided from the outside of the engine and are
    # shared for all the engines. They include build_path and additional details
    # and need to be valid with InsightsEngine::Schemas::Params validation
    # schema
    attr_reader :params
    # Buffer is used to build the final result step by step and to accumulate
    # partial data that is being populated with more details and informations
    attr_reader :buffer

    # Method used to execute engine and validate source code. It will execute
    #   checking and will validate the output to make sure it meets the output
    #   requirements
    # @note If you want to review the output hash structure, please review the
    #   InsightsEngine::Schemas::Result validation schema
    # @note Initial parameters are validated using
    #   InsightsEngine::Schemas::Params validation schema
    # @param args [Array<Object>] Initial parameters for the validation
    # @return [Hash] hash with all the validation data
    def call(*args)
      @params = Params.new(*args)
      buffer = process
      validate!(buffer)
      buffer
    end

    private

    # Runs a given harvester than uses parser to extract and return properly
    # formatted data
    # @return Parsed results
    def process
      self.class.parser.new.call(
        self.class.harvester.new.call(params)
      )
    end

    # Checks the output data before we return it based on the
    #   InsightsEngine::Schemas::Result validation schema.
    # @param results [Hash] hash that we want to validate
    # @raise [InsightsEngine::Errors::InvalidAttributes] raised when our hash
    #   does not meet requirements from the schema
    def validate!(results)
      data = results.is_a?(Array) ? results : [results]
      data.each do |result|
        self.class.schema.call(result)
      end
    end
  end
end
