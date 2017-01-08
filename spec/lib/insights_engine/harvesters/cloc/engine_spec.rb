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
      context 'language not str' do
        let(:input) do
          {
            languages: [
              { language: nil, files: 18, blank: 167, comment: 21, code: 672 }
            ]
          }
        end

        it { expect { described_class.schema.call(input) }.to raise_error(InsightsEngine::Errors::InvalidAttributes) }
      end

      context 'files negative' do
        let(:input) do
          {
            languages: [
              { language: 'Ruby', files: -1, blank: 167, comment: 21, code: 672 }
            ]
          }
        end

        it { expect { described_class.schema.call(input) }.to raise_error(InsightsEngine::Errors::InvalidAttributes) }
      end

      context 'blank negative' do
        let(:input) do
          {
            languages: [
              { language: 'Ruby', files: 18, blank: -1, comment: 21, code: 672 }
            ]
          }
        end

        it { expect { described_class.schema.call(input) }.to raise_error(InsightsEngine::Errors::InvalidAttributes) }
      end

      context 'comment negative' do
        let(:input) do
          {
            languages: [
              { language: 'Ruby', files: 18, blank: 167, comment: -1, code: 672 }
            ]
          }
        end

        it { expect { described_class.schema.call(input) }.to raise_error(InsightsEngine::Errors::InvalidAttributes) }
      end

      context 'code negative' do
        let(:input) do
          {
            languages: [
              { language: 'Ruby', files: 18, blank: 167, comment: 21, code: -1 }
            ]
          }
        end

        it { expect { described_class.schema.call(input) }.to raise_error(InsightsEngine::Errors::InvalidAttributes) }
      end
    end
  end
end
