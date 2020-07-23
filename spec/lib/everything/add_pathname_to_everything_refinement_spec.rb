require 'everything'
require './lib/everything/add_pathname_to_everything_refinement'

class RefinedContext
  using Everything::AddPathnameToEverythingRefinement

  def pathname
    Everything.pathname
  end
end

describe Everything::AddPathnameToEverythingRefinement do
  include_context 'stub out everything path'

  context 'when using the refinement' do
    let(:refined_context) do
      RefinedContext.new
    end
    let(:expected_pathname) do
      Pathname.new(Everything.path)
    end

    it 'adds the pathname method to Everything' do
      expect(refined_context.pathname).to eq(expected_pathname)
    end
  end
end
