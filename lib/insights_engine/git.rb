# frozen_string_literal: true
module InsightsEngine
  # Wrapper for executing git commands
  # @note You should not run any git commands directly. Always use this wrapper
  # @note Methods that are here don't format return values in any way, except
  #   splitting results by lines
  # @note Each of those methods should raise an exception if anything goes wrong
  class Git
    class << self
      # Returns a shortlog describing all the commiters for project that is
      #   under build_path
      # @param build_path [String] path of a current repository build
      # @return [Array<String>] Lines returned by the git shortlog command
      # @example
      #   InsightsEngine::Git.shortlog('./') #=>
      #   ["    13\tMaciej Mensfeld <maciej@mensfeld.pl>"]
      def shortlog(build_path)
        shell(build_path, :shortlog, '-sn -e --all')
      end

      # Returns an information about last commiter that changed/created this
      #   file. We use it to blame users for file related errors, assuming that
      #   the fault goes always to a person that changed the file last and
      #   didn't correct or created a particular error
      # @param build_path [String] path of a current repository build
      # @param location [String] location of a file (without build_path)
      # @return [Array<String>] Lines returned by the git log command
      # @example
      #   InsightsEngine::Git.log('./', 'Gemfile') #=>
      #   ["commit 68c066bb5e0dc3ef5", "Author: M..."]
      def log(build_path, location)
        shell(
          build_path,
          :log,
          "-n 1 --word-diff=porcelain --date=raw '#{location}'"
        )
      end

      # Returns blame details about a given line
      # @param build_path [String] path of a current repository build
      # @param location [String] location of a file without build_path
      # @param location_line [Integer] line that we want to blame against
      # @return [Array<String>] Lines returned by the git blame command
      # @example
      #   InsightsEngine::Git.blame('./', 'Gemfile', 2) #=>
      #   ["68c066bb5e0dc... 2 2 1", "author Maciej"]
      def blame(build_path, location, location_line)
        options = "-t -L #{location_line},#{location_line} " \
          '--incremental --porcelain'

        shell(build_path, :blame, "'#{location}' #{options}")
      end

      def shortstat(build_path, limit = nil, commit = nil)
        options = []
        options << '--shortstat'
        options << '--format="oneline"'
        options << "-n#{limit}" if limit
        options << commit if commit

        shell(build_path, :log, options.join(' '))
      end

      def effort(build_path, above = 10)
        options = []
        options << "--above #{above}"
        # Remove all the colors from output
        options << '| sed "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'
        options << '| sort -rn -k 2'
        options << '| uniq'
        shell(build_path, :effort, options.join(' '))
      end

      def ls_files(build_path)
        shell(build_path, 'ls-files', '| wc -l')
      end

      private

      # Executes a given git command in build_path location
      # @param build_path [String] path of a current repository build
      # @param command [Symbol] name of a git command that we want to execute
      # @param arguments [String] all arguments accepted by this git command
      # @raise [InsightsEngine::Errors::FailedGitCommand] raised when git
      #   command didn't run with success
      # @example
      #   shell(
      #     '/home/builds/91',
      #     :log,
      #     "-n 1 --word-diff=porcelain --date=raw #{location}"
      #   )
      def shell(build_path, command, arguments)
        command_with_options = "git -C #{build_path} #{command} #{arguments}"
        result = Shell.call(command_with_options)

        return result[:stdout].split("\n") if result[:exit_code].zero?

        raise Errors::FailedGitCommand, "#{command_with_options}: " \
          "#{result[:stderr]}"
      end
    end
  end
end
