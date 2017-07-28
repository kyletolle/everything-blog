require 'active_support'
require 'active_support/core_ext/hash/keys'

# Got this idea from: https://stackoverflow.com/questions/8126802/when-testing-with-rspec-where-to-put-common-test-utility-methods
module PostHelpers
  def create_post(post_name, title:'Blah', body:'Super blah, foo blah.', is_public: false, created_at: nil, wordpress: nil)
    piece_path = File.join(Everything::Blog::Source.absolute_path, post_name)
    piece = Everything::Piece.new(piece_path)

    FileUtils.mkdir_p(piece.full_path)

    File.open(piece.content.file_path, 'w') do |f|
      f.write("# #{title}\n\n#{body}")
    end

    metadata = {}.tap do |h|
      h['public'] = is_public || false
      h['wordpress'] = wordpress.deep_stringify_keys if wordpress
      h['created_at'] =
        if created_at
          created_at
        elsif !wordpress
          Time.now.to_i
        end
    end

    File.open(piece.metadata.file_path, 'w') do |f|
      f.write(metadata.to_yaml)
    end
  end

  def create_media_for_post(post_name)
    piece_path = File.join(Everything::Blog::Source.absolute_path, post_name)

    ['jpg', 'mp3'].each do |media_type|
      media_path = File.join(piece_path, "lala.#{media_type}")
      File.open(media_path, 'w') do |f|
        f.write('whoop-de-doo')
      end
    end
  end

  def delete_post(post_name)
    piece_path = File.join(Everything::Blog::Source.absolute_path, post_name)

    FileUtils.rm_rf(piece_path)
  end
end

