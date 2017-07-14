# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::HeadDetails::Parser do
  specify { expect(described_class).to be < InsightsEngine::Engine::Parser }

  subject(:parser) { described_class.new }

  let(:params) do
    InsightsEngine::Engine::Params.new(
      build_path: InsightsEngine.gem_root,
      snapshotted_at: Date.today
    )
  end
  let(:stdout) do
    InsightsEngine::Harvesters::HeadDetails::Harvester.new.call(params)
  end

  before { parser.instance_variable_set(:'@raw', stdout) }

  describe '#process' do
    let(:output) { parser.send(:process) }

    it { expect(output).not_to be_empty }
    it { expect(output).to be_an_instance_of(Hash) }
    it { expect(output.keys.count).to eq(10) }

    [
      :commit_hash,
      :message,
      :branch,
      :authored_at,
      :committed_at,
      { author: %i[name email] },
      { committer: %i[name email] },
      :files_changed,
      :insertions,
      :deletions
    ].each do |k|
      if k.instance_of?(Hash)
        k.each do |kk, v|
          it { expect(output).to have_key(kk) }
          v.each do |kkk|
            it { expect(output[kk]).to have_key(kkk) }
          end
        end
      else
        it do
          expect(output).to have_key(k)
        end
      end
    end
  end
end
