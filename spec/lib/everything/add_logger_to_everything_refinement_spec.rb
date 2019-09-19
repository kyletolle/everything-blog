require 'everything'
require './lib/everything/add_logger_to_everything_refinement'

describe Everything do
  context 'when using the refinement' do
    using Everything::AddLoggerToEverythingRefinement

    after { Everything.logger = nil }

    describe '#logger' do
      it 'can be used' do
        expect{ Everything.logger }.not_to raise_error
      end

      it 'defaults to a logger', :aggregate_failures do
        actual_logger = Everything.logger
        expect(actual_logger).to be_a_kind_of(Logger)
        expect(actual_logger.level).to eq(Logger::ERROR)
        expect(actual_logger.progname).to eq(Module.to_s)
      end
    end

    describe '#logger=' do
      let(:test_logger) do
        instance_double(Logger)
      end

      it 'can be used' do
        expect{ Everything.logger = test_logger }.not_to raise_error
      end

      it 'stores the value passed in' do
        Everything.logger = test_logger

        expect(Everything.logger).to eq(test_logger)
      end
    end
  end
end
