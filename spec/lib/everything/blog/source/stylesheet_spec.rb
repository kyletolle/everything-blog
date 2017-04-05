require 'pp'
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
      it 'returns the content of the stylesheet file' do
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
end

