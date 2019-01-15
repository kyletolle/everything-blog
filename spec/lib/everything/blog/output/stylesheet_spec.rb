require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/output/stylesheet'

describe Everything::Blog::Output::Stylesheet do
  let(:stylesheet) do
    described_class.new(source_stylesheet)
  end

  describe '#initialize'
  describe '#source_file'
  describe '#output_file_name'
  describe '#output_dir_path'
  describe '#output_file_path'
  describe '#relative_dir_path'
  describe '#save_file'
  describe '#should_generate_output?'
end
