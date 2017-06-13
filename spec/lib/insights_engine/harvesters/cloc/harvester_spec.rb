# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::Cloc::Harvester do
  specify { expect(described_class).to be < InsightsEngine::Engine::Harvester }

  subject(:harvester) { described_class.new }

  let(:scope) { InsightsEngine::Harvesters::Cloc }
  let(:params) do
    InsightsEngine::Engine::Params.new(
      build_path: InsightsEngine.gem_root,
      snapshotted_at: Date.today
    )
  end

  before { harvester.instance_variable_set(:'@params', params) }

  describe '#process' do
    let(:command) do
      cmd = []
      cmd << 'yarn run --silent cloc -- --yaml --quiet --progress-rate=0'
      cmd << params.build_path
      cmd.join(' ')
    end

    before do
      expect(SupportEngine::Shell::Utf8).to receive(:call_in_path)
        .with(InsightsEngine.gem_root, command, raise_on_invalid_exit: false)
        .and_return(stdout: '', stderr: '', exit_code: 0)
    end

    it 'expect to run cloc with proper arguments' do
      harvester.send(:process)
    end
  end
end
