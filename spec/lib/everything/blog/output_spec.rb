require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/output'

describe Everything::Blog::Output do
  shared_context 'stub out blog output path' do
    let(:fake_blog_output_path) do
      '/fake/blog/output'
    end
    let(:expected_absolute_path) do
      fake_blog_output_path
    end

    before do
      without_partial_double_verification do
        allow(Fastenv)
          .to receive(:blog_output_path)
          .and_return(fake_blog_output_path)
      end
    end
  end

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

