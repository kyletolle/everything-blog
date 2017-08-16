require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/output/index'
require 'fakefs/spec_helpers'
require './spec/support/shared'
require './spec/support/post_helpers'

describe Everything::Blog::Output::Index do
  include FakeFS::SpecHelpers
  include PostHelpers

  include_context 'with fakefs'
  include_context 'create blog path'
  include_context 'stub out blog output path'

  before do
    create_post('some-title', is_public: true)
  end

  after do
    delete_post('some-title')
  end

  let(:source_index) do
    Everything::Blog::Source::Index.new({'some-title' => 'Blah'})
  end
  let(:index) do
    described_class.new(source_index)
  end

  describe '#output_file_name' do
    it 'is an index html file' do
      expect(index.output_file_name).to eq('index.html')
    end
  end

  describe '#output_dir_path' do
    let(:expected_output_dir_path) do
      fake_blog_output_path
    end

    it 'is the full path for the output dir' do
      expect(index.output_dir_path).to eq(expected_output_dir_path)
    end
  end

  describe '#output_file_path' do
    let(:expected_output_file_path) do
      File.join(fake_blog_output_path, index.output_file_name)
    end

    it 'is the full path for the output file' do
      expect(index.output_file_path).to eq(expected_output_file_path)
    end
  end

  describe '#relative_dir_path' do
    it 'should be the same path as the source index' do
      expect(index.relative_dir_path).to eq(source_index.relative_dir_path)
    end
  end

  describe '#save_file' do
    context 'when an index template does not exist' do
      include_examples 'raises an error for index template not existing'
    end

    context 'when an index template exists' do
      let(:expected_file_data_regex) do
        /\<html.*\>/
      end

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
          FileUtils.rm(index.output_file_path)
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
          expect(File.exist?(index.output_file_path)).to eq(false)

          index.save_file

          expect(File.exist?(index.output_file_path)).to eq(true)
        end

        it 'writes the HTML file data' do
          # TODO: If we want to test this in finer detail, we might want to
          # test the interaction with Tilt and all that, so we aren't hardcoding
          # a lot of HTML into the spec file.
          index.save_file

          index_file_data = File.read(index.output_file_path)
          expect(index_file_data).to match(expected_file_data_regex)
        end
      end

      context 'when the file already exists' do
        before do
          FileUtils.mkdir_p(fake_blog_output_path)
          File.write(index.output_file_path, 'random text')
        end

        it 'does not delete the file' do
          expect(File.exist?(index.output_file_path)).to eq(true)

          index.save_file

          expect(File.exist?(index.output_file_path)).to eq(true)
        end

        it 'overwrites it with the correct file data' do
          index_file_data = File.read(index.output_file_path)
          expect(index_file_data).not_to match(expected_file_data_regex)

          index.save_file

          index_file_data = File.read(index.output_file_path)
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
end

