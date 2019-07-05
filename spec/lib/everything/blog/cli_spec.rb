require './spec/support/shared'
require './lib/everything/blog/cli'

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

    shared_context "calls blog's generate_site" do
      it 'passes the logger to the blog' do
        cli

        expect(Everything::Blog)
          .to have_received(:new)
          .with(logger: fake_logger)
      end

      it "calls blog's generate_site" do
        cli

        expect(fake_blog)
          .to have_received(:generate_site)
      end
    end

    context 'with no options' do
      include_context "calls blog's generate_site"

      it 'sets the logger level to error' do
        cli

        expect(fake_logger.level)
          .to eq(Logger::ERROR)
      end
    end

    context 'with an option of the' do
      shared_context 'handles verbose logging' do
        it 'sets the logger level to info' do
          cli

          expect(fake_logger.level)
            .to eq(Logger::INFO)
        end
      end

      shared_context 'handles debug logging' do
        it 'sets the logger level to debug' do
          cli

          expect(fake_logger.level)
            .to eq(Logger::DEBUG)
        end
      end

      context 'short verbose flag' do
        let(:given_cli_arguments) do
          ['generate', '-v']
        end

        include_context "calls blog's generate_site"

        it 'accepts a short verbose flag' do
          expect{ cli }.not_to raise_error
        end

        include_examples 'handles verbose logging'
      end

      context 'long verbose flag' do
        let(:given_cli_arguments) do
          ['generate', '--verbose']
        end

        include_context "calls blog's generate_site"

        it 'accepts a short verbose flag' do
          expect{ cli }.not_to raise_error
        end

        include_examples 'handles verbose logging'
      end

      context 'short debug flag' do
        let(:given_cli_arguments) do
          ['generate', '-d']
        end

        include_context "calls blog's generate_site"

        it 'accepts a short debug flag' do
          expect{ cli }.not_to raise_error
        end

        include_examples 'handles debug logging'
      end

      context 'long debug flag' do
        let(:given_cli_arguments) do
          ['generate', '--debug']
        end

        include_context "calls blog's generate_site"

        it 'accepts a long debug flag' do
          expect{ cli }.not_to raise_error
        end

        include_examples 'handles debug logging'
      end

      context 'long verbose flag and the long debug flag' do
        let(:given_cli_arguments) do
          ['generate', '--verbose', '--debug']
        end

        include_context "calls blog's generate_site"

        it 'accepts both flags' do
          expect{ cli }.not_to raise_error
        end

        include_examples 'handles debug logging'
      end

      context 'long debug flag and the long verbose flag' do
        let(:given_cli_arguments) do
          ['generate', '--debug', '--verbose']
        end

        include_context "calls blog's generate_site"

        it 'accepts both flags' do
          expect{ cli }.not_to raise_error
        end

        include_examples 'handles debug logging'
      end
    end
  end
end
