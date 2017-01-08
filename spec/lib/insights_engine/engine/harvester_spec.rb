# frozen_string_literal: true
RSpec.describe InsightsEngine::Engine::Harvester do
  subject(:harvester) { harvester_class.new }
  let(:harvester_class) { described_class }

  let(:build_path) { '/tmp' }
  let(:params_base) do
    InsightsEngine::Engine::Params.new(
      build_path: build_path
    )
  end

  let(:params) { object_double(params_base, build_path: build_path) }

  describe '#call' do
    let(:harvester_class) do
      Class.new(described_class) do
        def process; end

        self
      end
    end

    it 'expect to set params and process' do
      harvester.call(params)
      expect(harvester.send(:params)).to eq params
    end
  end

  describe '#process' do
    let(:error) { InsightsEngine::Errors::ImplementationMissing }
    it { expect { harvester.send(:process) }.to raise_error(error) }
  end

  describe '#run' do
    let(:command_with_options) { rand.to_s }

    before do
      harvester.instance_variable_set(:'@params', params)
    end

    it 'expect tu run shell commands in a sources path context' do
      expect(InsightsEngine::Shell)
        .to receive(:call)
        .with(command_with_options)

      harvester.send(:run, command_with_options)
    end
  end

  describe '#raw' do
    subject(:result) { described_class.new.send(:raw, stdout, stderr, exit_code) }

    let(:stdout) { rand.to_s }
    let(:stderr) { '' }
    let(:exit_code) { 0 }

    context 'when there is no exit code provided' do
      let(:exit_code) { false }

      context 'and stderr is empty' do
        it { expect(result[:exit_code]).to eq 0 }
        it { expect(result[:stdout]).to eq stdout }
        it { expect(result[:stderr]).to eq stderr }
      end

      context 'and stderr is not empty' do
        let(:stderr) { rand.to_s }

        it { expect(result[:exit_code]).to eq 1 }
        it { expect(result[:stdout]).to eq stdout }
        it { expect(result[:stderr]).to eq stderr }
      end
    end

    context 'when there is exit code provided' do
      let(:exit_code) { rand }

      it { expect(result[:exit_code]).to eq exit_code }
      it { expect(result[:stdout]).to eq stdout }
      it { expect(result[:stderr]).to eq stderr }
    end
  end
end
