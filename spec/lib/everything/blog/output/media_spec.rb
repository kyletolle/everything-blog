require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/output/index'
require 'fakefs/spec_helpers'
require './spec/support/shared'
require './spec/support/post_helpers'

describe Everything::Blog::Output::Index do
  include FakeFS::SpecHelpers
  include PostHelpers

  include_context 'with fakefs'
  include_context 'create blog path'
  include_context 'stub out blog output path'

  include_context 'with fake png'

  let(:source_media) do
    # TODO: Need to create this with a source file... Which, remind me, is what
    # again? Just a path? Yes, the Source::PostsFinder uses the media paths.
    Everything::Blog::Source::Media.new(test_png_file_path)
  end
  let(:media) do
    described_class.new(source_media)
  end

  #TODO: This is giving me some trouble when I try to add this new spec.
  describe '#output_file_name' do
    it 'is the source file name' do
      expect(media.output_file_name).to eq('1x1_black_square.png')
    end
  end
end

