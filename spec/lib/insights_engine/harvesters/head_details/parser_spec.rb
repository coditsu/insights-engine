# frozen_string_literal: true

RSpec.describe_current do
  subject(:parser) { described_class.new }

  let(:params) do
    InsightsEngine::Engine::Params.new(
      build_path: SupportEngine::Git::RepoBuilder::Master.location,
      default_branch: 'master'
    )
  end
  let(:stdout) do
    InsightsEngine::Harvesters::HeadDetails::Harvester.new.call(params)
  end

  before do
    # We have to stub this one, because it detach into a given commit and we check against
    # ourselves (current repo)
    allow(SupportEngine::Git::Commits).to receive(:originated_from).and_return(rand.to_s)
    parser.instance_variable_set(:'@raw', stdout)
  end

  specify { expect(described_class).to be < InsightsEngine::Engine::Parser }

  describe '#process' do
    let(:output) { parser.send(:process) }

    it { expect(output).not_to be_empty }
    it { expect(output).to be_an_instance_of(Hash) }
    it { expect(output.keys.count).to eq(8) }
    it { expect(output[:branch]).to eq 'master' }

    [
      :commit_hash,
      :diff_hash,
      :message,
      :branch,
      :authored_at,
      :committed_at,
      { author: %i[name email] },
      { committer: %i[name email] }
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
