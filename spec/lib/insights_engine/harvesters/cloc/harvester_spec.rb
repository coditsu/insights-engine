# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::Cloc::Harvester do
  specify { expect(described_class).to be < InsightsEngine::Engine::Harvester }

  subject(:harvester) { described_class.new }

  let(:scope) { InsightsEngine::Harvesters::Cloc }
  let(:params) do
    InsightsEngine::Engine::Params.new(
      build_path: InsightsEngine.gem_root
    )
  end

  before { harvester.instance_variable_set(:'@params', params) }

  describe '#process' do
    let(:command) do
      "cloc --yaml --quiet --progress-rate=0 #{params.build_path}"
    end

    it 'expect to run cloc with proper arguments' do
      expect(InsightsEngine::Shell).to receive(:call)
        .with(command)
      harvester.send(:process)
    end
  end
end
