require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/source/stylesheet'
require 'fakefs/spec_helpers'

describe Everything::Blog::Source::Stylesheet do
  include FakeFS::SpecHelpers

  let(:stylesheet) do
    described_class.new
  end

  def create_fake_stylesheet(stylesheet_content)
    FakeFS do
      FileUtils.mkdir('css')
      stylesheet_filename = File.join('css', 'style.css')
      File.open(stylesheet_filename, 'w') do |f|
        f.write stylesheet_content
      end
    end
  end

  describe '#content' do
    FakeFS do
      it 'is the content of the stylesheet file' do
        given_stylesheet_content = 'fake stylesheet content'
        expected_stylesheet_content = given_stylesheet_content

        create_fake_stylesheet(given_stylesheet_content)

        expect(stylesheet.content).to eq(expected_stylesheet_content)
      end
    end
  end

  describe '#file_name' do
    let(:expected_file_name) { 'style.css' }
    it 'is the default stylesheet name' do
      expect(stylesheet.file_name).to eq(expected_file_name)
    end
  end

  describe '#relative_dir_path' do
    it 'is a relative path to the dir' do
      expect(stylesheet.relative_dir_path).to eq('css')
    end
  end

  describe '#relative_file_path' do
    it 'is a relative path to the file' do
      expect(stylesheet.relative_file_path).to eq('css/style.css')
    end
  end

  # TODO: Make it check the absolute path
  describe '#==' do
    context 'when the other stylesheet has a different file name' do
      let(:other_stylesheet) do
        described_class.new
          .tap do |style|
            def style.file_name
              'another_style.css'
            end
          end
      end

      it 'is false' do
        expect(stylesheet == other_stylesheet).to eq(false)
      end
    end

    context 'when the other stylesheet has the same file_name' do
      let(:other_stylesheet) do
        described_class.new
      end

      it 'is true' do
        expect(stylesheet == other_stylesheet).to eq(true)
      end
    end
  end
end

