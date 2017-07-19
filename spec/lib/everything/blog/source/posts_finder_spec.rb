require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/source/posts_finder'
# require './spec/support/shared'
# require 'fakefs/spec_helpers'

describe Everything::Blog::Source::PostsFinder do
  # include FakeFS::SpecHelpers

  #TODO: Need to add specs here.
end

