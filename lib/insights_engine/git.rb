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

      # Runs a git log with --shortstats option
      # @param build_path [String] path of a current repository build
      # @param limit [Integer, nil] number of lines that we want
      # @param commit [String, nil] commit name or nil if we want shortstat for all
      #   commits
      # @return [Array<String>] Lines returned by the git log --shortstat command
      # @example
      #   InsightsEngine::Git.blame('./', 2) #=>
      #   [
      #     '4 files changed, 13 insertions(+), 36 deletions(-)',
      #     'ab7928cc003e2306c9d7ec729fb1d87e808337c0 ninshiki'
      #   ]
      def shortstat(build_path, limit = nil, commit = nil)
        options = []
        options << '--shortstat'
        options << '--format="oneline"'
        options << "-n#{limit}" if limit
        options << commit if commit

        shell(build_path, :log, options.join(' '))
      end

      # @param build_path [String] path of a current repository build
      # @return [DateTime] datetime of a head commit
      def head_committed_at(build_path)
        Time.parse(shell(build_path, :log, '-1 --format=%cd')[0])
      end

      # Runs git effort
      # @see https://github.com/tj/git-extras
      # @note We remove all the colors and sort before returning results
      # @param build_path [String] path of a current repository build
      # @param since [String] since when we want to check offerts
      # @param above [Integer] above what effort level we expect results. It is useless
      #   to get all of them as it takes a lot of time and most of the time, the most interesting
      #   once are those with higher rank
      # @return [Array<String>] array with blame results
      # @example InsightsEngine::Git.blame('./', '2017-02-01', 5) #=>
      # [
      #   "  Gemfile.lock................................. 8           7",
      #   "  path      ..."
      # ]
      def effort(build_path, since, above = 10)
        options = []
        options << "--above #{above}"
        options << '--'
        options << "--since=\"#{since}\""

        # Remove all the colors from the output
        options << '| sed "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'
        options << '| sort -rn -k 2'
        options << '| uniq'
        shell(build_path, :effort, options.join(' '))
      end

      # Runs git ls-files and counts those lines, so we can get number of files in this repo
      # that are tracked using git
      # @param build_path [String] path of a current repository build
      # @return [Array<String>] Array with ls-files count results
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
