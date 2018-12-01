require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/output/page'
require 'fakefs/spec_helpers'
require './spec/support/shared'

describe Everything::Blog::Output::Page do
  include FakeFS::SpecHelpers

  include_context 'with fakefs'
  include_context 'create blog path'
  include_context 'stub out blog output path'

  # Create a post so we can make a page from it
  # Note: Borrowed some of this from blog/source/page_spec
  include_context 'with fake piece'
  let(:given_piece_path) do
    # We want to create our fake posts in the blog directory.
    File.join(Everything::Blog::Source.absolute_path, given_post_name)
  end
  let(:given_post) do
    Everything::Blog::Post.new(given_post_name)
  end

  let(:given_source_page) do
    Everything::Blog::Source::Page.new(given_post)
  end
  let(:page) do
    described_class.new(given_source_page)
  end

  describe '#should_generate_output?' do
    # TODO: Want to make this smarter and use the conditionals in code, but need
    # to have tests for that...
    it 'is always true' do
      expect(page.should_generate_output?).to eq(true)
    end
  end

  describe '#source_file' do
    it 'is the given source page' do
      expect(page.source_file).to eq(given_source_page)
    end
  end

  describe '#template_context' do
    it "is the source file's post" do
      expect(page.template_context).to eq(given_post)
    end
  end

  describe '#output_file_name' do
    it 'is index.html' do
      expect(page.output_file_name).to eq('index.html')
    end
  end

  describe '#output_file_path' do
    it 'is the full path of the post dir and the index.html' do
      expect(page.output_file_path).to eq('/fake/blog/output/grond-crawled-on/index.html')
    end
  end

  describe '#output_dir_path' do
    it 'is the full path of the post dir' do
      expect(page.output_dir_path).to eq('/fake/blog/output/grond-crawled-on')
    end
  end

  describe '#relative_dir_path' do
    it 'is the relative path of the post dir' do
      expect(page.relative_dir_path).to eq('/grond-crawled-on')
    end
  end

  describe '#save_file' do
    context 'when a post template does not exist' do
      let(:action) do
        page.save_file
      end

      include_examples 'raises an error for post template not existing'
    end

    context 'when a post template exists' do
      let(:expected_file_data_regex) do
        /\<html.*\>/
      end

      include_context 'with a post template'

      context 'when the blog output path does not already exist' do
        it 'creates it' do
          expect(Dir.exist?(fake_blog_output_path)).to eq(false)

          page.save_file

          expect(Dir.exist?(fake_blog_output_path)).to eq(true)
        end
      end

      context 'when the blog output path already exists' do
        let(:fake_file_path) do
          File.join(fake_blog_output_path, 'something.txt')
        end

        before do
          FileUtils.mkdir_p(fake_blog_output_path)
          File.write(fake_file_path, 'fake file')
        end

        after do
          FileUtils.rm(fake_file_path)
          FileUtils.rm(page.output_file_path)
          FileUtils.rm(page.output_dir_path)
          FileUtils.rmdir(fake_blog_output_path)
        end

        it 'keeps the folder out there' do
          expect(Dir.exist?(fake_blog_output_path)).to eq(true)

          page.save_file

          expect(Dir.exist?(fake_blog_output_path)).to eq(true)
        end

        it 'does not clear existing files in the folder' do
          expect(File.exist?(fake_file_path)).to eq(true)

          page.save_file

          expect(File.exist?(fake_file_path)).to eq(true)
        end
      end

      context 'when the file does not already exist' do
        it 'creates it' do
          expect(File.exist?(page.output_file_path)).to eq(false)

          page.save_file

          expect(File.exist?(page.output_file_path)).to eq(true)
        end

        it 'writes the HTML file data' do
          # TODO: If we want to test this in finer detail, we might want to
          # test the interaction with Tilt and all that, so we aren't hardcoding
          # a lot of HTML into the spec file.
          page.save_file

          page_file_data = File.read(page.output_file_path)
          expect(page_file_data).to match(expected_file_data_regex)
        end
      end

      context 'when the file already exists' do
        before do
          FileUtils.mkdir_p(page.output_dir_path)
          File.write(page.output_file_path, 'random text')
        end

        it 'does not delete the file' do
          expect(File.exist?(page.output_file_path)).to eq(true)

          page.save_file

          expect(File.exist?(page.output_file_path)).to eq(true)
        end

        it 'overwrites it with the correct file data' do
          page_file_data = File.read(page.output_file_path)
          expect(page_file_data).not_to match(expected_file_data_regex)

          page.save_file

          page_file_data = File.read(page.output_file_path)
          expect(page_file_data).to match(expected_file_data_regex)
        end
      end
    end
  end
end

