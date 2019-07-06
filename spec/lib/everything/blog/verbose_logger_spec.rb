require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/verbose_logger'

describe Everything::Blog::VerboseLogger do
  let(:fake_output) do
    StringIO.new
  end

  subject(:logger) do
    described_class.new(fake_output)
  end

  describe '#initialize' do
    context 'with no logdev param given' do
      subject(:logger) do
        described_class.new
      end

      it 'raises an error' do
        expect { logger }.to raise_error(ArgumentError)
      end
    end

    context 'with a logdev param given' do
      context 'with no progname param given' do
        it 'returns a logger' do
          expect(logger).to be_a_kind_of(Logger)
        end

        it 'sets the log level to info' do
          expect(logger.level).to eq(Logger::INFO)
        end

        it 'sets the progname to nil' do
          expect(logger.progname).to be_nil
        end
      end

      context 'with a progname param given' do
        let(:given_progname) { 'Specs' }
        subject(:logger) do
          described_class.new(fake_output, progname: given_progname)
        end

        it 'returns a logger' do
          expect(logger).to be_a_kind_of(Logger)
        end

        it 'sets the log level to info' do
          expect(logger.level).to eq(Logger::INFO)
        end

        it 'sets the progname to the given value' do
          expect(logger.progname).to eq(given_progname)
        end
      end
    end
  end

  describe '#info' do
    it 'logs just the datetime and the message' do
      Timecop.freeze(DateTime.parse('2019-07-05 12:12:12 -0600')) do
        logger.info("Important message")

        expected_logger_output =
          "2019-07-05 12:12:12 -0600: Important message\n"
        expect(fake_output.string)
          .to eq(expected_logger_output)
      end
    end
  end
end

