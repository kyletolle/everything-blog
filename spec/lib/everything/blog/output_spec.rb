require 'spec_helper'

describe Everything::Blog::Output do
  describe '.absolute_path' do
    include_context 'stub out blog output path'

    let(:expected_absolute_dir) do
      Pathname.new(fake_blog_output_path)
    end

    it 'is the absolute dir' do
      expect(described_class.absolute_dir).to eq(expected_absolute_dir)
    end
  end
end

