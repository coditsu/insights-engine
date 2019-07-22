# frozen_string_literal: true

RSpec.describe_current do
  describe 'class elements' do
    subject(:populator_class) { described_class }

    describe '#fetcher' do
      let(:value) { rand }

      after { populator_class.fetcher = nil }

      it 'expect fetcher to be assignable' do
        populator_class.fetcher = value
        expect(populator_class.fetcher).to eq value
      end
    end
  end

  describe 'instance elements' do
    subject(:populator) { populator_class.new }

    let(:populator_class) { described_class }
    let(:params) { instance_double(InsightsEngine::Engine::Params) }
    let(:buffer) { { rand => rand } }

    describe '#call' do
      let(:populator_class) do
        Class.new(described_class) do
          def process; end

          self
        end
      end

      it 'expect to set params, buffer and process' do
        populator.call(params, buffer)
        expect(populator.send(:params)).to eq params
        expect(populator.send(:buffer)).to eq buffer
      end
    end

    describe '#process' do
      let(:error) { InsightsEngine::Errors::ImplementationMissing }

      it { expect { populator.send(:process) }.to raise_error(error) }
    end

    describe '#fetcher' do
      let(:fetcher_class) { Class.new }

      before { described_class.fetcher = fetcher_class }

      it 'expect to use fetcher class to build a new fetcher' do
        expect(populator.send(:fetcher)).to an_instance_of(fetcher_class)
      end
    end
  end
end
