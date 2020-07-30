require 'spec_helper'

describe Everything::Blog::Output do
  describe '.absolute_dir' do
    include_context 'stub out blog output path'

    let(:expected_absolute_dir) do
      Pathname.new(fake_blog_output_path)
    end

    it 'is the absolute dir' do
      expect(described_class.absolute_dir).to eq(expected_absolute_dir)
    end
  end

  describe '.templates_dir' do
    include_context 'stub out templates path'

    let(:expected_templates_dir) do
      Pathname.new(
        fake_templates_path
      )
    end

    it 'is the templates dir' do
      expect(described_class.templates_dir).to eq(expected_templates_dir)
    end
  end
end

