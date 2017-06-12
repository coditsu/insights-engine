# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::FilesExtensions::Harvester do
  specify { expect(described_class).to be < InsightsEngine::Engine::Harvester }

  subject(:harvester) { described_class.new }

  let(:scope) { InsightsEngine::Harvesters::FilesExtensions }
  let(:path) { SupportEngine::Git::RepoBuilder::Master.location }
  let(:params) { InsightsEngine::Engine::Params.new(build_path: path) }

  before { harvester.instance_variable_set(:'@params', params) }

  describe '#process' do
    let(:output) { harvester.send(:process) }
    let(:stdout) { output[:stdout].split("\n").map(&:strip) }

    it { expect(output).to have_key(:stdout) }
    it { expect(output[:stdout]).to be_an_instance_of(String) }
    it { expect(output).to have_key(:stderr) }
    it { expect(output[:stderr]).to be_empty }
    it { expect(output).to have_key(:exit_code) }
    it { expect(output[:exit_code]).to eq(0) }
    it { expect(stdout.size).to eq(1) }
    it { expect(stdout).to include('1 rb') }
    it { expect(stdout).not_to include('1 git') }
  end
end
