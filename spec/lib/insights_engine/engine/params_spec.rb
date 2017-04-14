# frozen_string_literal: true

RSpec.describe InsightsEngine::Engine::Params do
  let(:settings_content) { rand.to_s }
  let(:args) do
    { build_path: InsightsEngine.gem_root, settings_content: settings_content }
  end

  describe '#initialize' do
    subject(:params) { described_class.new(args) }

    context 'when schema is invalid' do
      let(:args) { {} }

      it do
        expect do
          params
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end

    context 'when schema is valid' do
      it { expect { params }.not_to raise_error }
      it { expect(params.settings).to eq settings_content.to_f }
    end
  end

  describe '#settings' do
    subject(:settings) { described_class.new(args).settings }

    it 'expect to have settings_content content' do
      expect(settings).to eq YAML.safe_load(settings_content)
    end
  end

  describe '#settings_file' do
    subject(:settings_file) { described_class.new(args).settings_file }

    it { expect(settings_file).to be_an_instance_of(Tempfile) }

    it 'expect to have settings_content content' do
      expect(File.open(settings_file).read).to eq settings_content
    end
  end
end
