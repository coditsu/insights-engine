# frozen_string_literal: true
RSpec.describe InsightsEngine::Engine::Parser do
  subject(:parser) { parser_class.new }
  let(:parser_class) { described_class }

  let(:raw) { {} }

  describe '#call' do
    let(:parser_class) do
      Class.new(described_class) do
        def process; end

        self
      end
    end

    it 'expect to set raw and process' do
      parser.call(raw)
      expect(parser.send(:raw)).to eq raw
    end
  end

  describe '#process' do
    let(:error) { InsightsEngine::Errors::ImplementationMissing }
    it { expect { parser.send(:process) }.to raise_error(error) }
  end
end
