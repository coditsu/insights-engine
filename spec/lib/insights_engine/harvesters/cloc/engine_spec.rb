# frozen_string_literal: true
RSpec.describe InsightsEngine::Harvesters::Cloc::Engine do
  let(:scope) { InsightsEngine::Harvesters::Cloc }

  specify { expect(described_class).to be < InsightsEngine::Engine }
  specify { expect(described_class.harvester).to eq scope::Harvester }
  specify { expect(described_class.parser).to eq scope::Parser }

  describe 'integration' do
    subject(:result) do
      described_class.new.call(
        build_path: InsightsEngine.gem_root
      )
    end

    it 'expect not to throw any errors' do
      expect { result }.not_to raise_error
    end
  end

  describe '#schema' do
    context 'no data' do
      let(:input) { {} }

      it { expect { described_class.schema.call(input) }.not_to raise_error }
    end

    context 'valid' do
      let(:input) do
        {
          languages: [
            { language: 'Ruby', files: 18, blank: 167, comment: 21, code: 672 }
          ]
        }
      end

      it { expect { described_class.schema.call(input) }.not_to raise_error }
    end

    context 'invalid' do
      let(:input) do
        {
          languages: [
            { language: 'Ruby', files: -1, blank: 167, comment: 21, code: 672 }
          ]
        }
      end

      context 'language not str' do
        before { input[:languages][0][:language] = nil }
        it { expect { described_class.schema.call(input) }.to raise_error(InsightsEngine::Errors::InvalidAttributes) }
      end

      %w(files blank comment code).each do |key|
        [-1, nil].each do |value|
          context "#{key} negative" do
            before { input[:languages][0][key] = value }
            it { expect { described_class.schema.call(input) }.to raise_error(InsightsEngine::Errors::InvalidAttributes) }
          end
        end
      end
    end
  end
end
