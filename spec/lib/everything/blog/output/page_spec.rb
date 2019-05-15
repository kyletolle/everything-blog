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
  include_context 'with fake source page'

  let(:given_piece_path) do
    # We want to create our fake posts in the blog directory.
    File.join(Everything::Blog::Source.absolute_path, given_post_name)
  end
  let(:given_post) do
    fake_post
  end
  let(:given_source_page) do
    fake_source_page
  end
  let(:page) do
    described_class.new(given_source_page)
  end

  describe '#should_generate_output?' do
    # Assuming the post template exists.
    include_context 'with a post template'

    context 'when page has never been saved before' do
      it 'is true' do
        expect(page.should_generate_output?).to eq(true)
      end
    end

    context 'when page has been saved before' do
      before do
        page.save_file
      end

      context 'when source markdown has not been modified since the page was saved' do
        context 'when source metadata has not been modified since the page was saved' do
          it 'is false' do
            expect(page.should_generate_output?).to eq(false)
          end
        end

        context 'when source metadata has been modified since the page was saved' do
          before do
            FileUtils.touch(given_post.piece.metadata.file_path)
          end

          it 'is true' do
            expect(page.should_generate_output?).to eq(true)
          end
        end
      end

      context 'when the source markdown has been modified since the page was saved' do
        before do
          FileUtils.touch(given_post.piece.content.file_path)
        end

        it 'is true' do
          expect(page.should_generate_output?).to eq(true)
        end
      end
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

  describe '#output_content' do
    let(:template_double) { instance_double(page.template_klass) }
    let(:fake_content_and_template) { '<p>Faked out, yo!</p>' }

    before do
      allow(page.template_klass)
        .to receive(:new)
        .and_return(template_double)
      allow(template_double)
        .to receive(:merge_content_and_template)
        .and_return(fake_content_and_template, 'Some other')
    end

    it 'returns merged template and content' do
      expect(page.output_content).to eq(fake_content_and_template)
    end

    it 'memoizes the return value' do
      expect(page.output_content.object_id)
        .to eq(page.output_content.object_id)
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
    it 'is the relative path of the post dir, without a leading slash' do
      expect(page.relative_dir_path).to eq('grond-crawled-on')
    end
  end

  describe '#relative_file_path' do
    it 'should be the same path as the source index' do
      expect(page.relative_file_path)
        .to eq(given_source_page.relative_file_path)
    end
  end

  describe '#save_file' do
    context 'when a post template does not exist' do
      let(:action) do
        page.save_file
      end

      include_examples 'raises an error for template not existing'
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
          FileUtils.rmdir(page.output_dir_path)
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

      context 'when the blog post output path already exists' do
        let(:fake_file_path) do
          File.join(page.output_dir_path, 'something.txt')
        end

        before do
          FileUtils.mkdir_p(page.output_dir_path)
          File.write(fake_file_path, 'fake file')
        end

        after do
          FileUtils.rm(fake_file_path)
          FileUtils.rm(page.output_file_path)
          FileUtils.rmdir(page.output_dir_path)
          FileUtils.rmdir(fake_blog_output_path)
        end

        it 'keeps the folder out there' do
          expect(Dir.exist?(page.output_dir_path)).to eq(true)

          page.save_file

          expect(Dir.exist?(page.output_dir_path)).to eq(true)
        end

        it 'does not clear files in the folder' do
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

  describe '#template_klass' do
    it 'is the output post template' do
      expect(page.template_klass)
        .to eq(Everything::Blog::Output::PostTemplate)
    end
  end
end

