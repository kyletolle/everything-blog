require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/source/site'
require 'fakefs/spec_helpers'
require './spec/support/shared'
require './spec/support/post_helpers'

describe Everything::Blog::Source::Site do
  include FakeFS::SpecHelpers
  include PostHelpers

  let(:site) do
    described_class.new
  end

  describe '#files' do
    include_context 'with fakefs'
    include_context 'create blog path'

    shared_context 'with private posts' do
      before do
        create_post('one-title', is_public: false)
        create_post('two-title', is_public: false)
      end

      after do
        delete_post('one-title')
        delete_post('two-title')
      end
    end

    shared_context 'with public posts' do
      before do
        create_post('three-title', is_public: true)
        create_post('four-title', is_public: true)
      end

      after do
        delete_post('three-title')
        delete_post('four-title')
      end
    end

    shared_examples 'includes the index and stylesheet' do
      it 'includes the index' do
        actual_index = site.files[0]
        expect(actual_index).to eq(expected_index)
      end

      it 'includes the stylesheet' do
        actual_stylesheet = site.files[1]
        expect(actual_stylesheet).to eq(expected_stylesheet)
      end
    end

    shared_examples 'includes no media' do
      it 'includes no media' do
        any_media = site.files.any?{|file| file.is_a?(Everything::Blog::Source::Media) }
        expect(any_media).to eq(false)
      end
    end

    shared_examples 'includes the public pages' do
      it 'includes some pages' do
        any_pages = site.files.any?{|file| file.is_a?(Everything::Blog::Source::Page) }
        expect(any_pages).to eq(true)
      end

      let(:actual_pages) do
        site.files.select{|file| file.is_a?(Everything::Blog::Source::Page) }
      end
      let(:three_post) do
        Everything::Blog::Post.new('three-title')
      end
      let(:three_page) do
        Everything::Blog::Source::Page.new(three_post)
      end
      let(:four_post) do
        Everything::Blog::Post.new('four-title')
      end
      let(:four_page) do
        Everything::Blog::Source::Page.new(four_post)
      end
      let(:expected_pages) do
        [three_page, four_page]
      end

      it 'includes the correct pages for the public posts' do
        expect(actual_pages).to match(expected_pages)
      end
    end

    context 'when there are only private posts' do
      include_context 'with private posts'

      let(:expected_index) do
        Everything::Blog::Source::Index.new([])
      end
      let(:expected_stylesheet) do
        Everything::Blog::Source::Stylesheet.new
      end
      include_examples 'includes the index and stylesheet'

      it 'includes no pages for posts' do
        any_pages = site.files.any?{|file| file.is_a?(Everything::Blog::Source::Page) }
        expect(any_pages).to eq(false)
      end

      include_examples 'includes no media'
    end

    context 'when there are private and public posts' do
      include_context 'with private posts'
      include_context 'with public posts'

      let(:expected_post_names_and_titles) do
        {
          'three-title' => 'Blah',
          'four-title' => 'Blah'
        }
      end
      let(:expected_index) do
        Everything::Blog::Source::Index.new(expected_post_names_and_titles)
      end
      let(:expected_stylesheet) do
        Everything::Blog::Source::Stylesheet.new
      end

      context' that have no media' do
        include_examples 'includes the index and stylesheet'
        include_examples 'includes the public pages'
        include_examples 'includes no media'
      end

      context 'that have media' do
        before do
          create_media_for_post('three-title')
          create_media_for_post('four-title')
        end

        include_examples 'includes the index and stylesheet'
        include_examples 'includes the public pages'

        # TODO: Need to clean up how we work with media files in tests.
        it 'includes some media' do
          any_media = site.files.any?{|file| file.is_a?(Everything::Blog::Source::Media) }
          expect(any_media).to eq(true)
        end

        let(:actual_media_files) do
          site.files.select{|file| file.is_a?(Everything::Blog::Source::Media) }
        end
        let(:three_media_files) do
          [
            Everything::Blog::Source::Media.new(File.join(Everything::Blog::Source.absolute_path, 'three-title', 'lala.jpg')),
            Everything::Blog::Source::Media.new(File.join(Everything::Blog::Source.absolute_path, 'three-title', 'lala.mp3'))
          ]
        end
        let(:four_media_files) do
          [
            Everything::Blog::Source::Media.new(File.join(Everything::Blog::Source.absolute_path, 'four-title', 'lala.jpg')),
            Everything::Blog::Source::Media.new(File.join(Everything::Blog::Source.absolute_path, 'four-title', 'lala.mp3'))
          ]
        end
        let(:expected_media_files) do
          [three_media_files, four_media_files].flatten
        end
        it 'includes the correct media for the public posts' do
          expect(actual_media_files).to eq(expected_media_files)
        end
      end
    end
  end
end

