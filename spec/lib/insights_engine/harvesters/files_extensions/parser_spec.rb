# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::FilesExtensions::Parser do
  specify { expect(described_class).to be < InsightsEngine::Engine::Parser }

  subject(:parser) { described_class.new }

  let(:stdout) do
    InsightsEngine::Harvesters::FilesExtensions::Harvester.new.call(
      InsightsEngine::Engine::Params.new(
        build_path: InsightsEngine.gem_root
      )
    )
  end

  before { parser.instance_variable_set(:'@raw', stdout) }

  describe '#process' do
    let(:output) { parser.send(:process) }

    it { expect(output).not_to be_empty }
    it { expect(output).to be_an_instance_of(Hash) }
    it { expect(output.count).to eq(1) }
    it { expect(output).to have_key(:files_extensions) }
    it { expect(output[:files_extensions].size).to eq(10) }
    it { expect(output[:files_extensions].first).to have_key(:name) }
    it { expect(output[:files_extensions].first).to have_key(:count) }
    it { expect(output[:files_extensions][0][:name]).to eq('rb') }
    it { expect(output[:files_extensions][0][:count]).to eq(92) }
  end
end
