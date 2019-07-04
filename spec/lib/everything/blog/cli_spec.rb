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
      shared_context 'handles logging' do
        it 'sets the logger level to info' do
          cli

          expect(fake_logger.level)
            .to eq(Logger::INFO)
        end

        it 'logs message when starting' do
          allow(fake_logger)
            .to receive(:info)

          cli

          expect(fake_logger)
            .to have_received(:info)
            .with(described_class::LOGGER_INFO_STARTING)
        end

        it 'logs message when complete' do
          allow(fake_logger)
            .to receive(:info)

          cli

          expect(fake_logger)
            .to have_received(:info)
            .with(described_class::LOGGER_INFO_COMPLETE)
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

        include_examples 'handles logging'
      end

      context 'long verbose flag' do
        let(:given_cli_arguments) do
          ['generate', '--verbose']
        end

        include_context "calls blog's generate_site"

        it 'accepts a short verbose flag' do
          expect{ cli }.not_to raise_error
        end

        include_examples 'handles logging'
      end
    end
  end
end
