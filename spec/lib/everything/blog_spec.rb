require 'spec_helper'
require './spec/support/post_helpers'

describe Everything::Blog do
  using Everything::AddLoggerToEverythingRefinement

  include_context 'with fake blog path'
  include_context 'with fake logger'

  let(:given_options) do
    {}
  end

  let(:blog) do
    described_class.new(given_options)
  end

  describe '::debug_logger' do
    let(:debug_logger) { described_class.debug_logger }

    it 'is an instance of the debug logger class' do
      expect(debug_logger).to be_a(Everything::Blog::DebugLogger)
    end

    it 'uses a log device of $stdout' do
      expect(Everything::Blog::DebugLogger)
        .to receive(:new)
        .with($stdout, anything)

      debug_logger
    end

    it 'passes a progname of the blog class' do
      expect(Everything::Blog::DebugLogger)
        .to receive(:new)
        .with(anything, progname: described_class.to_s)

      debug_logger
    end
  end

  describe '::error_logger' do
    let(:error_logger) { described_class.error_logger }

    it 'is an instance of the error logger class' do
      expect(error_logger).to be_a(Everything::Blog::ErrorLogger)
    end

    it 'uses a log device of $stdout' do
      expect(Everything::Blog::ErrorLogger)
        .to receive(:new)
        .with($stdout, anything)

      error_logger
    end

    it 'passes a progname of the blog class' do
      expect(Everything::Blog::ErrorLogger)
        .to receive(:new)
        .with(anything, progname: described_class.to_s)

      error_logger
    end
  end

  describe '::verbose_logger' do
    let(:verbose_logger) { described_class.verbose_logger }

    it 'is an instance of the verbose logger class' do
      expect(verbose_logger).to be_a(Everything::Blog::VerboseLogger)
    end

    it 'uses a log devise of $stdout' do
      expect(Everything::Blog::VerboseLogger)
        .to receive(:new)
        .with($stdout, anything)

      verbose_logger
    end

    it 'passes a progname of the blog class' do
      expect(Everything::Blog::VerboseLogger)
        .to receive(:new)
        .with(anything, progname: described_class.to_s)

      verbose_logger
    end
  end

  describe '#initialize' do
    context 'with no arguments given' do
      let(:blog) do
        described_class.new
      end

      it 'does not raise an error' do
        expect{ blog }.not_to raise_error
      end

      it 'sets options attr to an empty hash' do
        expect(blog.options).to eq({})
      end
    end

    context 'with an options arguments given' do
      let(:given_options) do
        {
          testing_out: :these_options
        }
      end

      it 'does not raise an error' do
        expect{ blog }.not_to raise_error
      end

      it 'sets options attr to the given options' do
        expect(blog.options).to eq(given_options)
      end
    end
  end

  describe '#logger' do
    subject(:actual_logger) { blog.logger }

    context 'when options are empty' do
      it 'is a logger' do
        expect(actual_logger).to be_a_kind_of(Everything::Blog::ErrorLogger)
      end

      it 'sets the logger progname to the class name' do
        expect(actual_logger.progname)
          .to eq(described_class.to_s)
      end
    end

    context 'when options are present and include' do
      # TODO: What about when verbose is equal to false?
      context 'only verbose' do
        let(:given_options) do
          {
            'verbose' => true
          }
        end

        it 'uses the verbose logger' do
          expect(actual_logger)
            .to be_a_kind_of(Everything::Blog::VerboseLogger)
        end
      end

      context 'only debug' do
      # TODO: What about when debug is equal to false?
        let(:given_options) do
          {
            'debug' => true
          }
        end

        it 'uses the debug logger' do
          expect(actual_logger)
            .to be_a_kind_of(Everything::Blog::DebugLogger)
        end
      end

      context 'verbose and debug' do
        let(:given_options) do
          {
            'verbose' => true,
            'debug' => true
          }
        end

        it 'uses the debug logger' do
          expect(actual_logger)
            .to be_a_kind_of(Everything::Blog::DebugLogger)
        end
      end
    end
  end

  describe '#generate_site' do
    let(:fake_source_files) { [] }

    before do
      allow_any_instance_of(Everything::Blog)
        .to receive(:source_files)
        .and_return(fake_source_files)
      allow(blog)
        .to receive(:logger)
        .and_return(fake_logger)
    end

    context 'when using the verbose logger' do
      let(:given_options) do
        {
          'verbose' => true
        }
      end

      it 'logs message when starting' do
        allow(fake_logger)
          .to receive(:info)

        blog.generate_site

        expect(fake_logger)
          .to have_received(:info)
          .with(described_class::LOGGER_INFO_STARTING)
      end

      it 'logs message when complete' do
        allow(fake_logger)
          .to receive(:info)

        blog.generate_site

        expect(fake_logger)
          .to have_received(:info)
          .with(described_class::LOGGER_INFO_COMPLETE)
      end
    end

    context 'when using the debug logger' do
      let(:given_options) do
        {
          'debug' => true
        }
      end

      it 'logs message when starting' do
        allow(fake_logger)
          .to receive(:info)

        blog.generate_site

        expect(fake_logger)
          .to have_received(:info)
          .with(described_class::LOGGER_INFO_STARTING)
      end

      it 'logs message when complete' do
        allow(fake_logger)
          .to receive(:info)

        blog.generate_site

        expect(fake_logger)
          .to have_received(:info)
          .with(described_class::LOGGER_INFO_COMPLETE)
      end
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

  describe '#source_site' do
    subject(:source_site) do
      blog.source_site
    end

    before do
      allow(blog)
        .to receive(:logger)
        .and_return(fake_logger)
    end

    it 'is a source site object' do
      expect(source_site)
        .to be_a_kind_of(Everything::Blog::Source::Site)
    end

    it 'passes the logger to the source site' do
      allow(Everything::Blog::Source::Site)
        .to receive(:new)

      source_site

      expect(Everything::Blog::Source::Site)
        .to have_received(:new)
        .with(fake_logger)
    end

    it 'memoizes the results' do
      expect(blog.source_site).to eq(source_site)
    end
  end

  describe '#use_debug_logger', aggregate_failures: true do
    let(:debug_logger) { Everything::Blog.debug_logger }

    it 'sets the Everything logger to be a debug logger' do
      expect(Everything.logger).not_to be_a(Everything::Blog::DebugLogger)

      blog.use_debug_logger

      expect(Everything.logger).to be_a(Everything::Blog::DebugLogger)
    end
  end
end
