# frozen_string_literal: true
RSpec.describe InsightsEngine::Harvesters::RepositoryAuthors::Parser do
  specify { expect(described_class).to be < InsightsEngine::Engine::Parser }

  subject(:parser) { described_class.new }

  let(:stdout) do
    InsightsEngine::Harvesters::RepositoryAuthors::Harvester.new.call(
      InsightsEngine::Engine::Params.new(
        build_path: InsightsEngine.gem_root
      )
    )
  end

  before { parser.instance_variable_set(:'@raw', stdout) }

  describe '#process' do
    let(:output) { parser.send(:process) }
    it { expect(output).not_to be_empty }
    it { expect(output).to be_an_instance_of(Array) }
    it { expect(output.count).to eq(2) }
  end
end
