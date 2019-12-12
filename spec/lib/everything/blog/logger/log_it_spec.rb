require 'spec_helper'

class DummyClass
  include Everything::Blog::Logger::LogIt
end

describe Everything::Blog::Logger::LogIt do
  using Everything::AddLoggerToEverythingRefinement

  subject { DummyClass.new }

  let(:expected_message) { 'A test message to log' }
  let(:expected_class_name) { subject.class.to_s }

  describe '#debug_it' do
    it 'calls Everything logger debug method' do
      expect(Everything.logger)
        .to receive(:debug)

      subject.debug_it(expected_message)
    end

    it 'calls Everything logger debug method with message in the block' do
      expect(Everything.logger)
        .to receive(:debug)
        .with(anything) do |&actual_block|
          expect(actual_block.call).to be(expected_message)
        end

      subject.debug_it(expected_message)
    end

    it 'calls Everything logger debug method with class name' do
      expect(Everything.logger)
        .to receive(:debug)
        .with(expected_class_name)

      subject.debug_it(expected_message)
    end
  end

  describe '#error_it' do
    it 'calls Everything logger error method' do
      expect(Everything.logger)
        .to receive(:error)

      subject.error_it(expected_message)
    end

    it 'calls Everything logger error method with message in the block' do
      expect(Everything.logger)
        .to receive(:error)
        .with(anything) do |&actual_block|
          expect(actual_block.call).to be(expected_message)
        end

      subject.error_it(expected_message)
    end

    it 'calls Everything logger error method with class name' do
      expect_any_instance_of(::Logger)
        .to receive(:error)
        .with(expected_class_name)

      subject.error_it(expected_message)
    end
  end

  describe '#info_it' do
    it 'calls Everything logger info method' do
      expect_any_instance_of(::Logger)
        .to receive(:info)

      subject.info_it(expected_message)
    end

    it 'calls Everything logger info method with message in the block' do
      expect(Everything.logger)
        .to receive(:info)
        .with(anything) do |&actual_block|
        expect(actual_block.call).to be(expected_message)
        end

      subject.info_it(expected_message)
    end

    it 'calls Everything logger info method with class name' do
      expect_any_instance_of(::Logger)
        .to receive(:info)
        .with(expected_class_name)

      subject.info_it(expected_message)
    end
  end
end

