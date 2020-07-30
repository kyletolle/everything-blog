require 'spec_helper'
require './spec/support/post_helpers'

describe Everything::Blog::Output::Index do
  include PostHelpers

  include_context 'stub out everything path'
  include_context 'with fake blog path'
  include_context 'stub out blog output path'
  include_context 'with one public post'
  include_context 'with fake source index'

  let(:source_index) { fake_source_index }
  let(:index) do
    described_class.new(source_index)
  end

  describe '#initialize' do
    it 'sets the source_file attr to the given source file' do
      expect(index.source_file).to eq(source_index)
    end
  end

  describe '#inspect' do
    let(:inspect_output_regex) do
      /#<#{described_class}: dir: `#{index.dir}`, file_name: `#{index.file_name}`>/
    end

    it 'returns a shorthand format with class name and file name' do
      expect(index.inspect).to match(inspect_output_regex)
    end
  end

  describe '#content' do
    let(:template_double) { instance_double(index.template_klass) }
    let(:fake_content_and_template) { '<p>Faked out, yo!</p>' }

    before do
      allow(index.template_klass)
        .to receive(:new)
        .and_return(template_double)
      allow(template_double)
        .to receive(:merge_content_and_template)
        .and_return(fake_content_and_template, 'Some other')
    end

    it 'returns merged template and content' do
      expect(index.content).to eq(fake_content_and_template)
    end

    it 'memoizes the return value' do
      expect(index.content.object_id)
        .to eq(index.content.object_id)
    end
  end

  describe '#absolute_dir' do
    let(:expected_absolute_dir) do
      Pathname.new(
        fake_blog_output_path
      )
    end

    it 'is the full path for the output dir' do
      expect(index.absolute_dir).to eq(expected_absolute_dir)
    end
  end

  describe '#file_name' do
    it 'is an index html file' do
      expect(index.file_name).to eq('index.html')
    end
  end

  describe '#absolute_path' do
    let(:expected_absolute_path) do
      Pathname.new(
        File.join(fake_blog_output_path, index.file_name)
      )
    end

    it 'is the full path for the output file' do
      expect(index.absolute_path).to eq(expected_absolute_path)
    end
  end

  describe '#dir' do
    it 'should be the same path as the source index' do
      expect(index.dir).to eq(source_index.dir)
    end
  end

  describe '#path' do
    it 'should be the same path as the source index' do
      expect(index.path).to eq(source_index.path)
    end
  end

  # TODO: Lots of overlap with blog/output/page_spec
  describe '#save_file' do
    include_context 'stub out templates path'

    context 'when an index template does not exist' do
      let(:action) do
        index.save_file
      end

      include_examples 'raises an error for template not existing'
    end

    context 'when an index template exists' do
      include_context 'with fake templates'

      let(:expected_file_data_regex) do
        /\<html.*\>/
      end

      include_context 'stub out templates path'
      include_context 'with an index template'

      context 'when the blog output path does not already exist' do
        it 'creates it' do
          expect(Dir.exist?(fake_blog_output_path)).to eq(false)

          index.save_file

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
          FileUtils.rm(index.absolute_path)
          FileUtils.rmdir(fake_blog_output_path)
        end

        it 'keeps the folder out there' do
          expect(Dir.exist?(fake_blog_output_path)).to eq(true)

          index.save_file

          expect(Dir.exist?(fake_blog_output_path)).to eq(true)
        end

        it 'does not clear existing files in the folder' do
          expect(File.exist?(fake_file_path)).to eq(true)

          index.save_file

          expect(File.exist?(fake_file_path)).to eq(true)
        end
      end

      context 'when the file does not already exist' do
        it 'creates it' do
          expect(File.exist?(index.absolute_path)).to eq(false)

          index.save_file

          expect(File.exist?(index.absolute_path)).to eq(true)
        end

        it 'writes the HTML file data' do
          # TODO: If we want to test this in finer detail, we might want to
          # test the interaction with Tilt and all that, so we aren't hardcoding
          # a lot of HTML into the spec file.
          index.save_file

          index_file_data = File.read(index.absolute_path)
          expect(index_file_data).to match(expected_file_data_regex)
        end
      end

      context 'when the file already exists' do
        before do
          FileUtils.mkdir_p(fake_blog_output_path)
          File.write(index.absolute_path, 'random text')
        end

        it 'does not delete the file' do
          expect(File.exist?(index.absolute_path)).to eq(true)

          index.save_file

          expect(File.exist?(index.absolute_path)).to eq(true)
        end

        it 'overwrites it with the correct file data' do
          index_file_data = File.read(index.absolute_path)
          expect(index_file_data).not_to match(expected_file_data_regex)

          index.save_file

          index_file_data = File.read(index.absolute_path)
          expect(index_file_data).to match(expected_file_data_regex)
        end
      end
    end
  end

  describe '#source_file' do
    it 'returns the source index it was created with' do
      expect(index.source_file).to eq(source_index)
    end
  end

  describe '#should_generate_output?' do
    # TODO: Add detection for whether the Index should generate or not.
    it 'should be true' do
      expect(index.should_generate_output?).to eq(true)
    end
  end

  describe '#template_klass' do
    it 'is the output index template' do
      expect(index.template_klass)
        .to eq(Everything::Blog::Output::IndexTemplate)
    end
  end
end

