# frozen_string_literal: true

RSpec.describe InsightsEngine::Git do
  subject(:git_class) { described_class }

  let(:build_path) { InsightsEngine.gem_root }
  let(:result) { "#{rand}\n" }
  let(:location) { 'Gemfile' }
  let(:location_line) { 5 }

  describe '#shortlog' do
    it 'expect to pass to shell command with proper arguments' do
      expect(InsightsEngine::Shell)
        .to receive(:call)
        .with("git -C #{build_path} shortlog -sn -e --all")
        .and_return(stdout: result, exit_code: 0)

      expect(git_class.shortlog(build_path)).to eq result.split("\n")
    end

    it 'expect to run a shortlog and return results in array' do
      expect(git_class.shortlog(build_path)).to be_a(Array)
    end

    it 'expect to include a single result' do
      # we expect at least two authors for the repository
      expect(git_class.shortlog(build_path).count).to be >= 2
    end
  end

  describe '#log' do
    let(:arguments) { "-n 1 --word-diff=porcelain --date=raw '#{location}'" }

    it 'expect to pass to shell command with proper arguments' do
      expect(InsightsEngine::Shell)
        .to receive(:call)
        .with("git -C #{build_path} log #{arguments}")
        .and_return(stdout: result, exit_code: 0)

      expect(git_class.log(build_path, location)).to eq result.split("\n")
    end

    it 'expect to run a log and return results in array' do
      expect(git_class.log(build_path, location)).to be_a(Array)
    end

    it 'expect to return proper elements in array' do
      # we expect at least 5 elements
      # commit, author, date, empty line, commit message, ..., ...
      expect(git_class.log(build_path, location).count).to be >= 5
    end
  end

  describe '#blame' do
    let(:command) do
      "git -C #{build_path} blame '#{location}' -t -L " \
        "#{location_line},#{location_line} --incremental --porcelain"
    end

    it 'expect to pass to shell command with proper arguments' do
      expect(InsightsEngine::Shell)
        .to receive(:call)
        .with(command)
        .and_return(stdout: result, exit_code: 0)

      expect(
        git_class.blame(build_path, location, location_line)
      ).to eq result.split("\n")
    end

    it 'expect to run a blame and return results in array' do
      expect(
        git_class.blame(build_path, location, location_line)
      ).to be_a(Array)
    end

    it 'expect to include a single result' do
      expect(
        git_class.blame(build_path, location, location_line).count
      ).to eq 12
    end
  end

  describe '#shell' do
    subject(:result) do
      described_class.send(:shell, build_path, command, arguments)
    end

    context 'when everything is ok' do
      let(:command) { :status }
      let(:arguments) { '' }

      it 'expect to execute git shell command' do
        expect { result }.not_to raise_error
      end

      it 'expect to return result in array' do
        expect(result).to be_a(Array)
      end
    end

    context 'when git command was invalid' do
      let(:command) { :non_existing }
      let(:arguments) { rand }

      it 'expect to raise error' do
        expect do
          result
        end.to raise_error(InsightsEngine::Errors::FailedGitCommand)
      end
    end

    context 'when git command failed' do
      let(:build_path) { '/' }
      let(:command) { :status }
      let(:arguments) { '' }

      it 'expect to raise error' do
        expect do
          result
        end.to raise_error(InsightsEngine::Errors::FailedGitCommand)
      end
    end
  end

  describe '#effort' do
    pending
  end

  describe '#head_committed_at' do
    pending
  end

  describe '#shortstat' do
    pending
  end
end
