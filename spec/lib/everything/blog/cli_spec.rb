require 'spec_helper'

describe Everything::Blog::CLI do
  describe '#generate' do
    include_context 'with fake logger'

    let(:given_cli_arguments) do
      ['generate']
    end

    let(:cli) do
      described_class
        .start(given_cli_arguments)
    end

    let(:fake_blog) do
      double(Everything::Blog)
    end

    let(:empty_options) do
      {}
    end

    let(:verbose_options) do
      {
        'verbose' => true
      }
    end
    let(:debug_options) do
      {
        'debug' => true
      }
    end
    let(:debug_and_verbose_options) do
      {
        'debug' => true,
        'verbose' => true
      }
    end

    before do
      allow(Everything::Blog)
        .to receive(:new)
        .and_return(fake_blog)
      allow(fake_blog)
        .to receive(:generate_site)
      allow(Logger)
        .to receive(:new)
        .and_return(fake_logger)
    end

    shared_context 'passes the correct options to the blog' do
      it 'passes the correct options to the blog' do
        cli

        expect(Everything::Blog)
          .to have_received(:new)
          .with(expected_options)
      end
    end

    shared_context "calls blog's generate_site" do

      it "calls blog's generate_site" do
        cli

        expect(fake_blog)
          .to have_received(:generate_site)
      end
    end

    context 'with no options' do
      let(:expected_options) { empty_options }
      include_context 'passes the correct options to the blog'

      include_context "calls blog's generate_site"
    end

    context 'with an option of the' do
      shared_context 'handles verbose logging' do
        let(:expected_options) { verbose_options }
        include_context 'passes the correct options to the blog'
      end

      shared_context 'handles debug logging' do
        let(:expected_options) { debug_options }
        include_context 'passes the correct options to the blog'
      end

      context 'short verbose flag' do
        let(:given_cli_arguments) do
          ['generate', '-v']
        end

        it 'accepts a short verbose flag' do
          expect{ cli }.not_to raise_error
        end

        include_examples 'handles verbose logging'

        include_context "calls blog's generate_site"
      end

      context 'long verbose flag' do
        let(:given_cli_arguments) do
          ['generate', '--verbose']
        end

        it 'accepts a long verbose flag' do
          expect{ cli }.not_to raise_error
        end

        include_examples 'handles verbose logging'

        include_context "calls blog's generate_site"
      end

      context 'short debug flag' do
        let(:given_cli_arguments) do
          ['generate', '-d']
        end

        it 'accepts a short debug flag' do
          expect{ cli }.not_to raise_error
        end

        include_examples 'handles debug logging'

        include_context "calls blog's generate_site"
      end

      context 'long debug flag' do
        let(:given_cli_arguments) do
          ['generate', '--debug']
        end

        it 'accepts a long debug flag' do
          expect{ cli }.not_to raise_error
        end

        include_examples 'handles debug logging'

        include_context "calls blog's generate_site"
      end

      context 'long verbose flag and the long debug flag' do
        let(:given_cli_arguments) do
          ['generate', '--verbose', '--debug']
        end

        it 'accepts both flags' do
          expect{ cli }.not_to raise_error
        end

        include_examples 'handles debug logging'

        include_context "calls blog's generate_site"
      end

      context 'long debug flag and the long verbose flag' do
        let(:given_cli_arguments) do
          ['generate', '--debug', '--verbose']
        end

        it 'accepts both flags' do
          expect{ cli }.not_to raise_error
        end

        include_examples 'handles debug logging'

        include_context "calls blog's generate_site"
      end
    end
  end
end
