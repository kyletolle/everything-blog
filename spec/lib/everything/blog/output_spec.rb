require 'spec_helper'

describe Everything::Blog::Output do
  describe '.absolute_path' do
    include_context 'stub out blog output path'

    it 'is the absolute output path' do
      expect(described_class.absolute_path).to eq(expected_absolute_path)
    end
  end

  describe '.absolute_pathname' do
    include_context 'stub out blog output path'

    let(:expected_absolute_pathname) do
      Pathname.new(fake_blog_output_path)
    end

    it 'is the absolute blog output pathname' do
      expect(described_class.absolute_pathname)
        .to eq(expected_absolute_pathname)
    end
  end
end

