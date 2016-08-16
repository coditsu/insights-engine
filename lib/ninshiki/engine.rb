# frozen_string_literal: true
module Ninshiki
  # Engine base class for other engines
  # Each engine is consisted from following parts:
  #   - validator - core part that performs analysis
  #   - parser - class responsible for parsing results into a format easier to work with
  #     (for example from string into YARD)
  #   - populators - array that should consist populators classes
  #   - settings - class that represents settings that should be applied into each validation
  #     settings are not used directly inside the gem, they are used to describe default settings
  #     for the UI so optionally used can change them. Settings with which a given validation is
  #     performed lie under params.settings_content key
  #
  # @note Each engine needs to implement all the attributes (even if they just inherit)
  # @note Final result of the validation needs to be valid with Ninshiki::Schemas::Result validation
  #   schema and if no exceptions are raised, it means that it will work with other parts of the
  #   Coditsu software
  # @note Note that you don't define any methods on the engine directly
  #
  # @example Example engine
  #   class Engine < Ninshiki::Engine
  #     self.parser = ExampleEngine::Parser
  #     self.settings = ExampleEngine::Settings
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
    # Validator class must inherit from Ninshiki::Engine::Parser
    class_attribute :parser
    # Schema that should be used to validate output of a given harvester
    class_attribute :schema
    # Validator class must inherit from Ninshiki::Engine::Settings
    class_attribute :settings

    # Input parameters that are provided from the outside of the engine and are shared for
    # all the engines. They include build_path and settings_content and need to be valid
    # with Ninshiki::Schemas::Params validation schema
    attr_reader :params
    # Buffer is used to build the final result step by step and to accumulate partial data
    # that is being populated with more details and informations
    attr_reader :buffer

    # Method used to execute engine and validate source code. It will execute checking and will
    #   validate the output to make sure it meets the output requirements
    # @note If you want to review the output hash structure, please review the
    #   Ninshiki::Schemas::Result validation schema
    # @note Initial parameters are validated using Ninshiki::Schemas::Params validation schema
    # @param args [Array<Object>] Initial parameters for the validation
    # @return [Hash] hash with all the validation data
    def call(*args)
      @params = Params.new(*args)
      buffer = process
      validate!(buffer)
      buffer
    ensure
      # This is a cleanup to remove validation configuration in case
      # something (anything) went wrong during the validation process
      @params.settings_file.unlink if @params
    end

    private

    def process
      self.class.parser.new.call(
        self.class.harvester.new.call(params)
      )
    end

    # Checks the output data before we return it based on the Ninshiki::Schemas::Result validation
    # schema.
    # @param results [Hash] hash that we want to validate
    # @raise [Ninshiki::Errors::InvalidAttributes] raised when our hash does not meet requirements
    #   from the schema
    def validate!(results)
      Array(results).each do |result|
        self.class.schema.call(result)
      end
    end
  end
end
