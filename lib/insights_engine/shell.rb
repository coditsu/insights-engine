# frozen_string_literal: true
module InsightsEngine
  # Wrapper for executing shell commands
  # @example Run ls
  #   InsightsEngine::Shell.('ls') =>
  #   { stdout: "test.rb\n", stderr: '', exit_code: 0}
  class Shell
    # Allows to execute shell commands and handle errors, etc later
    #   (won't raise any errors but instead will catch all things)
    # @param command_with_options [String] command that should be executed with
    #   all the arguments and options
    # @return [Hash] hash with 3 keys describing output
    #   (stdout, stderr, exit_code)
    # @example Run ls
    #   InsightsEngine::Shell.('ls') =>
    #   { stdout: "test.rb\n", stderr: '', exit_code: 0}
    def self.call(command_with_options)
      stdout_str, stderr_str, status = Open3.capture3(command_with_options)

      {
        stdout: stdout_str,
        stderr: stderr_str,
        exit_code: status.exitstatus
      }
    end
  end
end
