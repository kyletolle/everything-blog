require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/output/page'
require 'fakefs/spec_helpers'
require './spec/support/shared'

describe Everything::Blog::Output::Page do
  include FakeFS::SpecHelpers

  include_context 'with fakefs'
  include_context 'create blog path'
  include_context 'stub out blog output path'

  let(:source_page) do
    Everything::Blog::Source::Page.new(given_post)
  end
  let(:page) do
    described_class.new(source_page)
  end

  describe '#should_generate_output?'
  describe '#template_context'
  describe '#source_file'
  describe '#output_file_name'
  describe '#output_dir_path'
  describe '#output_file_path'
  describe '#relative_dir_path'
  describe '#save_file'
end

