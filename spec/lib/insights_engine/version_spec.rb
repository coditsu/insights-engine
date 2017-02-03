# frozen_string_literal: true
RSpec.describe InsightsEngine do
  let(:valid_engines) do
    described_class::Engine
      .descendants
      .select { |class_name| class_name.to_s.include?('Harvesters::') }
  end

  it 'expect to have a version that matches number of engines' do
    expect(
      valid_engines.count
    ).to eq described_class::VERSION.split('.')[1].to_i
  end
end
