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
    it 'returns a logger' do
      expect(logger).to be_a_kind_of(Logger)
    end

    it 'sets the log level to info' do
      expect(logger.level).to eq(Logger::INFO)
    end
  end

  describe '#info' do
    it 'logs just the datetime and the message' do
      Timecop.freeze(DateTime.parse('2019-07-05 12:12:12 -0600')) do
        logger.info("Important message")

        expected_logger_output = "2019-07-05 12:12:12 -0600: Important message\n"
        expect(fake_output.string)
          .to eq(expected_logger_output)
      end
    end
  end
end

