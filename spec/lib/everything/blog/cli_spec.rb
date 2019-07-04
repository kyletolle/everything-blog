require './lib/everything/blog/cli'

describe Everything::Blog::CLI do
  describe '#generate' do
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
    let(:fake_logger) do
      Logger.new(fake_output)
    end
    let(:fake_output) do
      StringIO.new
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
      context 'short verbose flag' do
        let(:given_cli_arguments) do
          ['generate', '-v']
        end

        include_context "calls blog's generate_site"

        it 'accepts a short verbose flag' do
          expect{ cli }.not_to raise_error
        end

        it 'logs two info messages' do
          allow(fake_logger)
            .to receive(:info)

          cli

          expect(fake_logger)
            .to have_received(:info)
            .twice
        end

        it 'sets the logger level to info' do
          cli

          expect(fake_logger.level)
            .to eq(Logger::INFO)
        end
      end

      context 'long verbose flag' do
        let(:given_cli_arguments) do
          ['generate', '--verbose']
        end

        include_context "calls blog's generate_site"

        it 'accepts a short verbose flag' do
          expect{ cli }.not_to raise_error
        end


        it 'logs two info messages' do
          allow(fake_logger)
            .to receive(:info)

          cli

          expect(fake_logger)
            .to have_received(:info)
            .twice
        end

        it 'sets the logger level to info' do
          cli

          expect(fake_logger.level)
            .to eq(Logger::INFO)
        end
      end
    end
  end
end
