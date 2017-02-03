# frozen_string_literal: true
RSpec.describe InsightsEngine do
  subject(:insights_engine) { described_class }

  describe '#engines' do
    let(:valid_engines) do
      insights_engine
        .engines
        .select { |class_name| class_name.to_s.include?('Harvesters::') }
    end

    it 'expect to pick all the engines' do
      expect(
        valid_engines.count
      ).to eq InsightsEngine::VERSION.split('.')[1].to_i
    end

    it 'expect them to be sorted' do
      sorted = valid_engines.sort_by(&:to_s)
      expect(valid_engines).to eql(sorted)
    end

    it 'expect not to include base engine' do
      expect(valid_engines).not_to include(InsightsEngine::Engine)
    end
  end

  describe '#gem_root' do
    it 'expect to point to root of the gem' do
      expect(
        insights_engine.gem_root
      ).to eq File.expand_path('../../..', __FILE__)
    end
  end
end
