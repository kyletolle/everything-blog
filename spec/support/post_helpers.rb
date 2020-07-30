require 'date'
require 'active_support'
require 'active_support/core_ext/hash/keys'
require 'fakefs/spec_helpers'
require './spec/support/shared'

# Got this idea from: https://stackoverflow.com/questions/8126802/when-testing-with-rspec-where-to-put-common-test-utility-methods
module PostHelpers
  def create_post(post_name, title:'Blah', body:'Super blah, foo blah.', is_public: false, created_on: nil)
    piece_path = Everything::Blog::Source.absolute_dir.join(post_name)
    piece = Everything::Piece.new(piece_path)

    FileUtils.mkdir_p(piece.absolute_dir)

    piece.content.absolute_path.write("# #{title}\n\n#{body}")

    metadata = {}.tap do |h|
      h['public'] = is_public || false
      h['created_on'] =
        if created_on
          created_on
        else
          Time.now.to_date.iso8601
        end
    end

    piece.metadata.absolute_path.write(metadata.to_yaml)
  end

  def create_media_for_post(post_name)
    piece_path = Everything::Blog::Source.absolute_dir.join(post_name)

    ['jpg', 'mp3'].each do |media_type|
      media_path = piece_path.join("lala.#{media_type}")
      media_path.write('whoop-de-doo')
    end
  end

  def delete_post(post_name)
    piece_path = Everything::Blog::Source.absolute_dir.join(post_name)

    FileUtils.rm_rf(piece_path)
  end
end

shared_context 'with fake blog path' do
  include_context 'with fakefs'
  include_context 'create blog path'
end

shared_context 'with private posts' do
  include PostHelpers

  before do
    create_post('one-title', is_public: false)
    create_post('two-title', is_public: false)
  end

  after do
    delete_post('one-title')
    delete_post('two-title')
  end
end

shared_context 'with public posts' do
  include PostHelpers

  before do
    create_post('three-title', is_public: true)
    create_post('four-title', is_public: true)
  end

  after do
    delete_post('three-title')
    delete_post('four-title')
  end
end

shared_context 'with one public post' do
  before do
    create_post('some-title', is_public: true)
  end

  after do
    delete_post('some-title')
  end
end
