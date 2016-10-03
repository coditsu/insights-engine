# frozen_string_literal: true
module InsightsEngine
  class Engine
    # Harvester base class for engine Harvesters
    # Harvester performs all the checkings and it should return preprocessed data based on
    # which we can then build final results using populators
    # In your own Harvester, you need to implement the #process method that will analyze
    # the source code and return results
    class Harvester
      # @param params [InsightsEngine::Engine::Params] build process params details
      # @return [Hash] hash with execution output results
      # @note selection parameter might not be present for external Harvesters, since they
      #   might have their own engines for selecting files for analysis
      def call(params)
        @params = params
        process
      end

      private

      attr_reader :params

      # This method needs to be implemented in a subclass
      # @return [Hash] raw output hash with stdout, stderr and exit_code
      # @raise [InsightsEngine::Errors::ImplementationMissing]
      def process
        raise InsightsEngine::Errors::ImplementationMissing
      end

      # Executes a given command in the build path context
      # @param command_with_options [String] shell command that we want to execute
      # @note This method only applies to shell/rake based Harvesters
      # @see InsightsEngine::Shell class documentation
      # @return [Hash] InsightsEngine::Shell execution hash
      def run(command_with_options)
        Shell.call(command_with_options)
      end

      # Builds a raw hash that can be used for further processing
      # @param stdout [String, Hash, Array] anything that we want to return as stdout
      # @param stderr [String, Hash, Array] any errors that occured
      # @return [Hash] hash with stdout, stderr and exit_code keys
      def raw(stdout = '', stderr = '', exit_code = false)
        {
          stdout: stdout,
          stderr: stderr,
          exit_code: exit_code || (stderr.empty? ? 0 : 1)
        }
      end
    end
  end
end
