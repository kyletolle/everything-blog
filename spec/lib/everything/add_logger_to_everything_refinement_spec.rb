require 'everything'
require './lib/everything/add_logger_to_everything_refinement'

class RefinedContext
  using Everything::AddLoggerToEverythingRefinement

  def logger
    Everything.logger
  end

  def logger=(value)
    Everything.logger = value
  end
end

describe Everything do
  context 'when using the refinement' do
    using Everything::AddLoggerToEverythingRefinement
    let(:refined_context) do
      RefinedContext.new
    end

    # let(:expected_pathname) do
    #   Pathname.new(Everything.path)
    # end

    # it 'adds the pathname method to Everything' do
    #   expect(refined_context.pathname).to eq(expected_pathname)
    # end

    # Note: respond_to? doesn't work for refinements
    # it 'adds a #logger method to Everything' do
    #   expect(Everything).to respond_to(:logger)
    # end

    # it 'adds a #logger= method to Everything' do
    #   expect(Everything).to respond_to(:logger=)
    # end

    it 'can use Everything.logger in a refined context' do
      expect{refined_context.logger}.not_to raise_error
    end

    it 'can use Everything.logger= in a refined context' do
      test_logger = instance_double(Logger)
      expect{refined_context.logger = test_logger}.not_to raise_error
    end

    # describe '#logger' do
    # end

    # describe '#logger=' do
    # end
  end
end
