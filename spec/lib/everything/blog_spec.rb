require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog'
require './spec/support/post_helpers'

describe Everything::Blog do
  include_context 'with fake blog path'
  include_context 'with fake logger'

  let(:blog) do
    described_class.new(logger: fake_logger)
  end


  describe '#initialize' do
    it "sets the logger attr to what's passed in" do
      expect(blog.logger).to eq(fake_logger)
    end
  end

  describe '#generate_site' do
    let(:fake_source_files) { [] }

    before do
      allow_any_instance_of(Everything::Blog)
        .to receive(:source_files)
        .and_return(fake_source_files)
    end

    it 'passes the source files to the output site' do
      expect(Everything::Blog::Output::Site)
        .to receive(:new)
        .with(fake_source_files)
        .and_call_original

      blog.generate_site
    end

    it 'calls generate on the output site' do
      expect_any_instance_of(Everything::Blog::Output::Site)
        .to receive(:generate)
        .once

      blog.generate_site
    end

    xit 'passes the output files to the s3 site'
    xit 'calls send on the s3 site'

    it 'returns itself' do
      expect(blog.generate_site).to eq(blog)
    end
  end

  describe '#source_files' do
    include_context 'with public posts'

    xit 'strips out missing files' do
      # TODO: I don't remember why the .compact was necessary.
    end

    it 'contains four source files' do
      expect(blog.source_files.count).to eq(4)
    end

    it 'includes the index file' do
      expect(blog.source_files.map(&:class))
        .to include(Everything::Blog::Source::Index)
    end

    it 'includes the stylesheet file' do
      expect(blog.source_files.map(&:class))
        .to include(Everything::Blog::Source::Stylesheet)
    end

    let(:expected_blog_post_names) do
      [
        /three-title/,
        /four-title/
      ]
    end
    it 'includes two blog post files' do
      actual_blog_pages = blog.source_files
        .select{|f| f.class == Everything::Blog::Source::Page }
      actual_blog_post_names = actual_blog_pages.map(&:post).map(&:name)
      expect(actual_blog_post_names).to match(expected_blog_post_names)
    end
  end
end
