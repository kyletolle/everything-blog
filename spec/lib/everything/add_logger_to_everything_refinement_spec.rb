require 'spec_helper'

describe Everything do
  context 'when using the refinement' do
    using Everything::AddLoggerToEverythingRefinement

    after { Everything.logger = nil }

    describe '#logger' do
      it 'can be used' do
        expect{ Everything.logger }.not_to raise_error
      end

      context 'when a logger is being overwritten' do
        before do
          let(:original_logger) do
            instance_double(Logger)
          end
          let(:new_logger) do
            instance_double(Logger)
          end

          before do
            Everything.logger = original_logger
          end

          it' is not the original logger' do
            expect(Everything.logger).not_to eq(original_logger)
          end
          it 'is the new logger' do
            expect(Everything.logger).to eq(new_logger)
          end
        end
      end

      context 'when a logger is not being overwritten' do
        context 'when a logger was previously set' do
          let(:test_logger) do
            instance_double(Logger)
          end

          before do
            Everything.logger = test_logger
          end

          it 'returns the previously given logger' do
            actual_logger = Everything.logger
            expect(actual_logger).to eq(test_logger)
          end

          it 'memoizes the value' do
            first_logger = Everything.logger
            second_logger = Everything.logger

            expect(first_logger.object_id).to eq(second_logger.object_id)
          end
        end

        context 'when a logger was not previously set' do
          it 'defaults to a Logger', :aggregate_failures do
            actual_logger = Everything.logger
            expect(actual_logger).to be_a_kind_of(Logger)
            expect(actual_logger.level).to eq(Logger::ERROR)
            expect(actual_logger.progname).to eq(Module.to_s)
          end

          it 'memoizes the value' do
            first_logger = Everything.logger
            second_logger = Everything.logger

            expect(first_logger.object_id).to eq(second_logger.object_id)
          end
        end
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
