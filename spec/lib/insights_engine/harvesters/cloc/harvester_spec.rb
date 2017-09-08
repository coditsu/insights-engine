# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::Cloc::Harvester do
  subject(:harvester) { described_class.new }

  let(:scope) { InsightsEngine::Harvesters::Cloc }
  let(:params) do
    InsightsEngine::Engine::Params.new(
      build_path: InsightsEngine.gem_root,
      snapshotted_at: Date.today
    )
  end

  before { harvester.instance_variable_set(:'@params', params) }

  specify { expect(described_class).to be < InsightsEngine::Engine::Harvester }

  describe '#process' do
    let(:call_args) { [InsightsEngine.gem_root, command, raise_on_invalid_exit: false] }
    let(:command) do
      cmd = []
      cmd << 'yarn run --silent cloc -- --yaml --quiet --progress-rate=0'
      cmd << params.build_path
      cmd.join(' ')
    end

    it 'expect to run cloc with proper arguments' do
      expect(SupportEngine::Shell::Utf8)
        .to receive(:call_in_path).with(*call_args).and_return(stdout: '', stderr: '', exit_code: 0)
      harvester.send(:process)
    end
  end
end
