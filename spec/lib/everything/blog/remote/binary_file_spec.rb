require 'pp' # helps prevent an error like: 'superclass mismatch for class file'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/remote/binary_file'

describe Everything::Blog::Remote::BinaryFile do
  # TODO: Add specs for these
  describe '#initialize'
  describe '#content'
  describe '#content_type'
  describe '#send'
end
