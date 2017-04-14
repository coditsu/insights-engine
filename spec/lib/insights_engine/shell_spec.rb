# frozen_string_literal: true

RSpec.describe InsightsEngine::Shell do
  describe '#call' do
    subject(:shell_result) { described_class.call(command_with_options) }

    context 'when we execute a valid shell command' do
      let(:command_with_options) { 'ls' }

      it 'expect to return a proper hash with data' do
        expect(shell_result[:stdout]).to include 'Gemfile'
        expect(shell_result[:stderr]).to be_empty
        expect(shell_result[:exit_code]).to eq 0
      end
    end

    context 'when we execute valid command with invalid options' do
      let(:command_with_options) { 'ls -no-such-option' }

      it 'expect to return a proper hash with errors' do
        expect(shell_result[:stdout]).not_to include 'Gemfile'
        expect(shell_result[:stderr]).not_to be_empty
        expect(shell_result[:exit_code]).not_to eq 0
      end
    end

    context 'when we execute invalid command' do
      let(:command_with_options) { 'no-such-command -x' }

      it 'expect to raise not catched error' do
        expect { shell_result }.to raise_error(Errno::ENOENT)
      end
    end
  end
end
