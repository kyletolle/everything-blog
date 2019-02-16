require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog'

describe Everything::Blog do
  let(:blog) do
    described_class.new
  end

  describe '#generate_site' do
    it 'passes the source files to the output site'
    it 'calls generate on the output site'
    xit 'passes the output files to the s3 site'
    xit 'calls send on the s3 site'
    it 'returns itself'
  end

  describe '#source_files' do
    it 'strips out missing files'
    it 'is the source files'
  end
end
