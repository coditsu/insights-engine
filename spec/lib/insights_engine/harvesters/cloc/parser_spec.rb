# frozen_string_literal: true
RSpec.describe InsightsEngine::Harvesters::Cloc::Parser do
  specify { expect(described_class).to be < InsightsEngine::Engine::Parser }

  subject(:parser) { described_class.new }

  let(:stdout) do
    <<-EOS

---
# github.com/AlDanial/cloc
header :
  cloc_url           : github.com/AlDanial/cloc
  cloc_version       : 1.70
  elapsed_seconds    : 0.0635077953338623
  n_files            : 18
  n_lines            : 860
  files_per_second   : 283.429772760548
  lines_per_second   : 13541.6446985595
Ruby :
  nFiles: 18
  blank: 167
  comment: 21
  code: 672
SUM:
  blank: 167
  comment: 21
  code: 672
  nFiles: 18
    EOS
  end

  let(:raw) { { stdout: stdout, exit_code: exit_code, stderr: rand } }
  let(:exit_code) { 0 }
  let(:result) do
    {
      languages: [
        { language: 'Ruby', files: 18, blank: 167, comment: 21, code: 672 },
        { language: 'SUM', files: 18, blank: 167, comment: 21, code: 672 }
      ]
    }
  end

  before { parser.instance_variable_set(:'@raw', raw) }

  describe '#process' do
    context 'when exit code is 0' do
      it { expect(parser.send(:process)).to eq result }
    end

    context 'when exit code is not 0' do
      let(:stdout) { '' }
      let(:result) do
        { languages: [] }
      end

      it { expect(parser.send(:process)).to eq(result) }
    end
  end
end
