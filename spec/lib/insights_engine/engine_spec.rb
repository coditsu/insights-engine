# frozen_string_literal: true

RSpec.describe InsightsEngine::Engine do
  describe 'class elements' do
    subject(:engine_class) { described_class }

    let(:value) { rand }

    %i[
      harvester parser schema
    ].each do |class_attribute|
      after { engine_class.public_send(:"#{class_attribute}=", nil) }

      it "expect #{class_attribute} to be assignable" do
        engine_class.public_send(:"#{class_attribute}=", value)
        expect(engine_class.public_send(class_attribute)).to eq value
      end
    end
  end

  describe 'instance elements' do
    subject(:engine) { engine_class.new }

    let(:engine_class) { described_class }
    let(:valid_params) { { build_path: '/tmp' } }
    let(:params) { instance_double(InsightsEngine::Engine::Params) }
    let(:parser) { instance_double(InsightsEngine::Engine::Parser) }
    let(:harvester) { instance_double(InsightsEngine::Engine::Harvester) }
    let(:schema) { instance_double(InsightsEngine::Schemas::Base) }
    let(:buffer) { {} }

    describe '#call' do
      before do
        described_class.harvester = InsightsEngine::Engine::Harvester
        described_class.parser = InsightsEngine::Engine::Parser
        described_class.schema = InsightsEngine::Schemas::Base
      end

      context 'std flow' do
        before do
          allow(described_class::Params).to receive(:new).with(valid_params).and_return(params)
          allow(described_class.harvester).to receive(:new).and_return(harvester)
          allow(harvester).to receive(:call).with(params)
          allow(described_class.parser).to receive(:new).and_return(parser)
          allow(parser).to receive(:call).and_return(params)
          allow(described_class.schema).to receive(:call).and_return(true)
        end

        it 'expect to run without problems' do
          expect { engine.call(valid_params) }.not_to raise_error
        end
      end

      context 'when building params failed' do
        it 'expect not to clean' do
          expect do
            engine.call({})
          end.to raise_error InsightsEngine::Errors::InvalidAttributes
        end
      end
    end
  end
end
