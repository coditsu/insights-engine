# frozen_string_literal: true

RSpec.describe_current do
  let(:scope) { InsightsEngine::Harvesters::HeadDetails }
  let(:params) do
    {
      build_path: SupportEngine::Git::RepoBuilder::Master.location,
      default_branch: 'master'
    }
  end
  let(:input) do
    described_class.parser.new.call(
      described_class.harvester.new.call(
        InsightsEngine::Engine::Params.new(params)
      )
    )
  end

  specify { expect(described_class).to be < InsightsEngine::Engine }
  specify { expect(described_class.harvester).to eq scope::Harvester }
  specify { expect(described_class.parser).to eq scope::Parser }

  describe 'integration' do
    subject(:result) do
      described_class.new.call(params)
    end

    it 'expect not to throw any errors' do
      expect { result }.not_to raise_error
    end
  end

  describe '#schema' do
    subject(:validation) { described_class.schema.new.call(input) }

    let(:error) { InsightsEngine::Errors::InvalidAttributes }

    context 'when we have valid data' do
      it { expect { validation }.not_to raise_error }
    end

    context 'when we have no data' do
      let(:input) { {} }

      it { expect { validation }.to raise_error error }
    end

    context 'when commit_hash is not a string' do
      before { input[:commit_hash] = rand }

      it { expect { validation }.to raise_error error }
    end

    context 'when commit_hash is an empty string' do
      before { input[:commit_hash] = '' }

      it { expect { validation }.to raise_error error }
    end

    context 'when diff_hash is not a string' do
      before { input[:diff_hash] = rand }

      it { expect { validation }.to raise_error error }
    end

    context 'when diff_hash is an empty string' do
      before { input[:diff_hash] = '' }

      it { expect { validation }.to raise_error error }
    end

    context 'when branch is not a string' do
      before { input[:branch] = rand }

      it { expect { validation }.to raise_error error }
    end

    context 'when branch is an empty string' do
      before { input[:branch] = '' }

      it { expect { validation }.to raise_error error }
    end

    context 'when message is not a string' do
      before { input[:message] = rand }

      it { expect { validation }.to raise_error error }
    end

    context 'when message is an empty string' do
      before { input[:message] = '' }

      it { expect { validation }.not_to raise_error }
    end

    context 'when message is nil' do
      before { input[:message] = nil }

      it { expect { validation }.not_to raise_error }
    end

    context 'when authored_at is not a date' do
      before { input[:authored_at] = rand }

      it { expect { validation }.to raise_error error }
    end

    context 'when authored_at is an empty string' do
      before { input[:authored_at] = '' }

      it { expect { validation }.to raise_error error }
    end

    context 'when authored_at is nil' do
      before { input[:authored_at] = nil }

      it { expect { validation }.to raise_error error }
    end

    context 'when committed_at is not a date' do
      before { input[:committed_at] = rand }

      it { expect { validation }.to raise_error error }
    end

    context 'when committed_at is an empty string' do
      before { input[:committed_at] = '' }

      it { expect { validation }.to raise_error error }
    end

    context 'when committed_at is nil' do
      before { input[:committed_at] = nil }

      it { expect { validation }.to raise_error error }
    end

    context 'when author is nil' do
      before { input[:author] = nil }

      it { expect { validation }.to raise_error error }
    end

    context 'when author is a random hash' do
      before { input[:author] = { rand => rand } }

      it { expect { validation }.to raise_error error }
    end

    context 'when author is missing a name' do
      before { input[:author][:name] = nil }

      it { expect { validation }.to raise_error error }
    end

    context 'when committer is nil' do
      before { input[:committer] = nil }

      it { expect { validation }.to raise_error error }
    end

    context 'when committer is a random hash' do
      before { input[:committer] = { rand => rand } }

      it { expect { validation }.to raise_error error }
    end

    context 'when committer is missing a name' do
      before { input[:committer][:name] = nil }

      it { expect { validation }.to raise_error error }
    end
  end
end
