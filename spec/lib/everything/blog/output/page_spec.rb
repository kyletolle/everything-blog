require 'spec_helper'

describe Everything::Blog::Output::Page do
  include_context 'stub out everything path'
  include_context 'with fakefs'
  include_context 'create blog path'
  include_context 'stub out blog output path'

  # Create a post so we can make a page from it
  # Note: Borrowed some of this from blog/source/page_spec
  include_context 'with fake source page'

  let(:given_piece_path) do
    # We want to create our fake posts in the blog directory.
    Everything::Blog::Source.absolute_dir.join(given_post_name)
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

  describe '#inspect' do
    let(:inspect_output_regex) do
      /#<#{described_class}: dir: `#{page.dir}`, file_name: `#{page.file_name}`>/
    end

    it 'returns a shorthand format with class name and file name' do
      expect(page.inspect).to match(inspect_output_regex)
    end
  end

  describe '#should_generate_output?' do
    # Assuming the post template exists.
    include_context 'with fake templates'

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
            FileUtils.touch(given_post.piece.metadata.absolute_path)
          end

          it 'is true' do
            expect(page.should_generate_output?).to eq(true)
          end
        end
      end

      context 'when the source markdown has been modified since the page was saved' do
        before do
          FileUtils.touch(given_post.piece.content.absolute_path)
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

  describe '#content' do
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
      expect(page.content).to eq(fake_content_and_template)
    end

    it 'memoizes the return value' do
      expect(page.content.object_id)
        .to eq(page.content.object_id)
    end
  end

  describe '#file_name' do
    it 'is index.html' do
      expect(page.file_name).to eq('index.html')
    end
  end

  describe '#absolute_path' do
    let(:expected_path) do
      Pathname.new('/fake/blog/output/grond-crawled-on/index.html')
    end

    it 'is the full path of the post dir and the index.html' do
      expect(page.absolute_path).to eq(expected_path)
    end
  end

  describe '#absolute_dir' do
    let(:expected_dir) do
      Pathname.new('/fake/blog/output/grond-crawled-on')
    end

    it 'is the full path of the post dir' do
      expect(page.absolute_dir).to eq(expected_dir)
    end
  end

  describe '#dir' do
    let(:expected_dir) do
      Pathname.new('grond-crawled-on')
    end

    it 'is the relative path of the post dir, without a leading slash' do
      expect(page.dir).to eq(expected_dir)
    end
  end

  describe '#path' do
    let(:expected_relative_file_path) do
      Pathname.new(
        given_source_page
          .path
          .to_s
          .gsub('md', 'html')
      )
    end

    it 'should be the same path as the source index, except an html file' do
      expect(page.path)
        .to eq(expected_relative_file_path)
    end
  end

  describe '#save_file' do
    include_context 'stub out templates path'

    context 'when a post template does not exist' do
      let(:action) do
        page.save_file
      end

      include_examples 'raises an error for template not existing'
    end

    context 'when a post template exists' do
      include_context 'with fake templates'

      let(:expected_file_data_regex) do
        /\<html.*\>/
      end

      include_context 'with a post template'

      context 'when the blog output path does not already exist' do
        it 'creates it' do
          expect(Everything::Blog::Output.absolute_dir).not_to exist

          page.save_file

          expect(Everything::Blog::Output.absolute_dir).to exist
        end
      end

      context 'when the blog output path already exists' do
        let(:fake_file_path) do
          Everything::Blog::Output.absolute_dir.join('something.txt')
        end

        before do
          Everything::Blog::Output.absolute_dir.mkpath
          fake_file_path.write('fake file')
        end

        after do
          FileUtils.rm(fake_file_path)
          FileUtils.rm(page.absolute_path)
          FileUtils.rmdir(page.absolute_dir)
          FileUtils.rmdir(Everything::Blog::Output.absolute_dir)
        end

        it 'keeps the folder out there' do
          expect(Everything::Blog::Output.absolute_dir).to exist

          page.save_file

          expect(Everything::Blog::Output.absolute_dir).to exist
        end

        it 'does not clear existing files in the folder' do
          expect(fake_file_path).to exist

          page.save_file

          expect(fake_file_path).to exist
        end
      end

      context 'when the blog post output path already exists' do
        let(:fake_file_path) do
          page.absolute_dir.join('something.txt')
        end

        before do
          page.absolute_dir.mkpath
          fake_file_path.write('fake file')
        end

        after do
          FileUtils.rm(fake_file_path)
          FileUtils.rm(page.absolute_path)
          FileUtils.rmdir(page.absolute_dir)
          FileUtils.rmdir(Everything::Blog::Output.absolute_dir)
        end

        it 'keeps the folder out there' do
          expect(page.absolute_dir).to exist

          page.save_file

          expect(page.absolute_dir).to exist
        end

        it 'does not clear files in the folder' do
          expect(fake_file_path).to exist

          page.save_file

          expect(fake_file_path).to exist
        end
      end

      context 'when the file does not already exist' do
        it 'creates it' do
          expect(page.absolute_path).not_to exist

          page.save_file

          expect(page.absolute_path).to exist
        end

        it 'writes the HTML file data' do
          # TODO: If we want to test this in finer detail, we might want to
          # test the interaction with Tilt and all that, so we aren't hardcoding
          # a lot of HTML into the spec file.
          page.save_file

          page_file_data = page.absolute_path.read
          expect(page_file_data).to match(expected_file_data_regex)
        end
      end

      context 'when the file already exists' do
        before do
          page.absolute_dir.mkpath
          page.absolute_path.write('random text')
        end

        it 'does not delete the file' do
          expect(page.absolute_path).to exist

          page.save_file

          expect(page.absolute_path).to exist
        end

        it 'overwrites it with the correct file data' do
          page_file_data = page.absolute_path.read
          expect(page_file_data).not_to match(expected_file_data_regex)

          page.save_file

          page_file_data = page.absolute_path.read
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

