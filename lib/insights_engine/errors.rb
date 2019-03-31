# frozen_string_literal: true

module InsightsEngine
  # All internal gem errors
  module Errors
    #  Base error class for all other errors
    class Base < StandardError; end
    # Raised when our engine output does not match schema exactly
    class InvalidAttributes < Base; end
    # Raised when we tried to execute a git command but for some reason it
    # failed
    class FailedGitCommand < Base; end
    # Raised when programmer needs to implement a given method in a subclass
    class ImplementationMissing < Base; end
    # Raised when we use case and we've got an unexpected type that we don't
    # support
    class InvalidType < Base; end
    # Raised when we execute a command but something went wrong and the
    # exception is not yet supported
    class InvalidResponse < Base; end
    # Raised when we receiver argument with an invalid value
    class InvalidArgumentValue < Base; end
    # Raised when we want details about commit but we cannot find any
    class UnmatchedCommit < Base; end
  end
end
