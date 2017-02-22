# frozen_string_literal: true
RSpec.describe InsightsEngine::Harvesters::GitEffort::Engine do
  let(:scope) { InsightsEngine::Harvesters::GitEffort }
  let(:params) { { build_path: InsightsEngine.gem_root } }

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

  let(:input) do
    described_class.parser.new.call(
      stdout: [
        '  F1.......... 30          15',
        '  config/locaf 10          8',
        '  tables.scss. 10          6',
        '  path         commits    active days',
        "\e[H\e[2J ",
        "\e[?25l",
        "\e[?12;25h\e(B\e[m"
      ]
    ).first
  end

  describe '#schema' do
    context 'default data' do
      it { expect { described_class.schema.call(input) }.not_to raise_error }
    end

    context 'no data' do
      let(:input) { {} }
      it do
        expect do
          described_class.schema.call(input)
        end.to raise_error(InsightsEngine::Errors::InvalidAttributes)
      end
    end

    context 'validation' do
      it_behaves_like :schemas_spec, :location, :required, :filled, :str?
      it_behaves_like :schemas_spec, :commits, :required, :filled, :int?, gteq?: 5
      it_behaves_like :schemas_spec, :active_days, :required, :filled, :int?, gt?: 0
    end
  end
end
