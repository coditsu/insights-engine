# frozen_string_literal: true

RSpec.describe InsightsEngine::Harvesters::CommitsDetails::Parser do
  specify { expect(described_class).to be < InsightsEngine::Engine::Parser }

  subject(:parser) { described_class.new }

  let(:params) do
    InsightsEngine::Engine::Params.new(
      build_path: InsightsEngine.gem_root
    )
  end
  let(:stdout) do
    InsightsEngine::Harvesters::CommitsDetails::Harvester.new.call(params)
  end

  before { parser.instance_variable_set(:'@raw', stdout) }

  describe '#process' do
    context 'when exit code is 0' do
      let(:output) { parser.send(:process) }

      it { expect(output).not_to be_empty }
      it { expect(output).to be_an_instance_of(Array) }

      [
        :commit_hash,
        :message,
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
            it { expect(output.first).to have_key(kk) }
            v.each do |kkk|
              it { expect(output.first[kk]).to have_key(kkk) }
            end
          end
        else
          it do
            expect(output.first).to have_key(k)
          end
        end
      end
    end

    context 'unmatched commit' do
      let(:commit) { stdout[:stdout][:shortstat].pop(2).first.split.first }

      it do
        expect do
          parser.send(:process)
        end.to raise_error(InsightsEngine::Errors::UnmatchedCommit, commit)
      end
    end
  end
end
