require 'spec_helper'
require './spec/support/post_helpers'

describe Everything::Blog::Output::Stylesheet do
  include_context 'stub out everything path'
  include_context 'with fake blog path'
  include_context 'stub out blog output path'
  include_context 'with fake source stylesheet'

  let(:given_source_stylesheet) do
    fake_source_stylesheet
  end
  let(:stylesheet) do
    described_class.new(given_source_stylesheet)
  end

  describe '#initialize' do
    it 'takes a source_file argument' do
      expect { stylesheet }.not_to raise_error
    end

    it 'sets the source_file attr' do
      expect(stylesheet.source_file).to eq(given_source_stylesheet)
    end
  end

  describe '#inspect' do
    let(:inspect_output_regex) do
      /#<#{described_class}: dir: `#{stylesheet.dir}`, file_name: `#{stylesheet.file_name}`>/
    end

    it 'returns a shorthand format with class name and file name' do
      expect(stylesheet.inspect).to match(inspect_output_regex)
    end
  end

  describe '#content' do
    include_context 'with fake stylesheet'

    it 'is the source content' do
      expect(stylesheet.content).to eq(given_source_stylesheet.content)
    end
  end

  describe '#file_name' do
    let(:css_stylesheet_file_pathname) do
      Pathname.new('style.css')
    end
    it 'is a style css file' do
      expect(stylesheet.file_name).to eq(css_stylesheet_file_pathname)
    end
  end

  describe '#absolute_dir' do
    let(:expected_absolute_dir) do
      Everything::Blog::Output.absolute_dir.join('css')
    end

    it 'is the full path for the output css dir' do
      expect(stylesheet.absolute_dir).to eq(expected_absolute_dir)
    end
  end

  describe '#absolute_path' do
    let(:expected_absolute_path) do
      Everything::Blog::Output.absolute_dir.join('css', stylesheet.file_name)
    end

    it 'is the full path for the output file' do
      expect(stylesheet.absolute_path).to eq(expected_absolute_path)
    end
  end

  describe '#dir' do
    it 'should be the same path as the source stylesheet' do
      expect(stylesheet.dir)
        .to eq(given_source_stylesheet.dir)
    end
  end

  describe '#path' do
    it 'should be the same path as the source index' do
      expect(stylesheet.path)
        .to eq(given_source_stylesheet.path)
    end
  end

  # TODO: Lots of overlap with blog/output/page_spec
  describe '#save_file' do
    include_context 'stub out templates path'

    context 'when a stylesheet does not exist' do
      let(:action) do
        stylesheet.save_file
      end

      include_examples 'raises an error for stylesheet not existing'
    end

    context 'when a stylesheet exists' do
      let(:expected_file_data_regex) do
        /p {.*}/
      end

      include_context 'with fake stylesheet'

      context 'when the blog output path does not already exist' do
        it 'creates it', :aggregate_failures do
          expect(Everything::Blog::Output.absolute_dir).not_to exist

          stylesheet.save_file

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
          fake_file_path.delete
          stylesheet.absolute_path.delete
          stylesheet.absolute_dir.rmdir
          Everything::Blog::Output.absolute_dir.rmdir
        end

        it 'keeps the folder out there, :aggregate_failures' do
          expect(Everything::Blog::Output.absolute_dir).to exist

          stylesheet.save_file

          expect(Everything::Blog::Output.absolute_dir).to exist
        end

        it 'does not clear existing files in the folder, :aggregate_failures' do
          expect(fake_file_path).to exist

          stylesheet.save_file

          expect(fake_file_path).to exist
        end
      end

      context 'when the file does not already exist' do
        it 'creates it, :aggregate_failures' do
          expect(stylesheet.absolute_path).not_to exist

          stylesheet.save_file

          expect(stylesheet.absolute_path).to exist
        end

        it 'write the CSS file data' do
          stylesheet.save_file

          stylesheet_file_data = stylesheet.absolute_path.read
          expect(stylesheet_file_data).to match(expected_file_data_regex)
        end
      end

      context 'when the file already exists' do
        before do
          stylesheet.absolute_dir.mkpath
          stylesheet.absolute_path.write('not even css')
        end

        it 'does not delete the file, :aggregate_failures' do
          expect(stylesheet.absolute_path).to exist

          stylesheet.save_file

          expect(stylesheet.absolute_path).to exist
        end

        it 'overwrites it with the correct file data, :aggregate_failures' do
          stylesheet_file_data = stylesheet.absolute_path.read
          expect(stylesheet_file_data).not_to match(expected_file_data_regex)

          stylesheet.save_file

          stylesheet_file_data = stylesheet.absolute_path.read
          expect(stylesheet_file_data).to match(expected_file_data_regex)
        end
      end
    end
  end

  describe '#should_generate_output?' do
    # TODO: Add detection for whether the Stylesheet should generate or not.
    it 'should be true' do
      expect(stylesheet.should_generate_output?).to eq(true)
    end
  end

  describe '#source_file' do
    it 'returns the source stylesheet it was created with' do
      expect(stylesheet.source_file).to eq(given_source_stylesheet)
    end
  end

  describe '#template_klass' do
    it 'is not implemented' do
      expect{stylesheet.template_klass}.to raise_error(NotImplementedError)
    end
  end
end

