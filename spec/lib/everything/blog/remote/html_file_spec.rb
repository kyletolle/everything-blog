require 'pp' # helps prevent an error like: 'superclass mismatch for class file'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/remote/html_file'

describe Everything::Blog::Remote::HtmlFile do
  # TODO: Add specs for these
  # include_context 'behaves like a Remote::FileBase'

  describe '#initialize'
  describe '#content'
  describe '#content_type'
  describe '#send'
end
