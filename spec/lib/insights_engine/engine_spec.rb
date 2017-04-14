# frozen_string_literal: true

RSpec.describe InsightsEngine::Engine do
  describe 'class elements' do
    subject(:engine_class) { described_class }

    let(:value) { rand }

    %i(
      harvester parser schema settings
    ).each do |class_attribute|
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
    let(:settings_file) { Tempfile.new }

    describe '#call' do
      before do
        described_class.harvester = InsightsEngine::Engine::Harvester
        described_class.parser = InsightsEngine::Engine::Parser
        described_class.schema = InsightsEngine::Schemas::Base
      end

      context 'std flow' do
        before do
          expect(described_class::Params)
            .to receive(:new)
            .with(valid_params)
            .and_return(params)

          expect(described_class.harvester).to receive(:new) { harvester }
          expect(harvester).to receive(:call).with(params)

          expect(described_class.parser).to receive(:new) { parser }
          expect(parser).to receive(:call) { params }

          expect(described_class.schema).to receive(:call) { true }

          expect(params).to receive(:settings_file)
            .and_return(settings_file)

          expect(settings_file).to receive(:unlink)
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

      context 'when something went wrong' do
        let(:engine_class) do
          Class.new(described_class) do
            def process
              raise StandardError
            end

            self
          end
        end

        before do
          expect(InsightsEngine::Engine::Params)
            .to receive(:new)
            .and_return(params)
        end

        it 'expect to unlink settings' do
          expect(params).to receive(:settings_file).and_return(settings_file)
          expect(settings_file).to receive(:unlink)
          expect { engine.call(valid_params) }.to raise_error(StandardError)
        end
      end
    end
  end
end
