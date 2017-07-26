# Got this idea from: https://stackoverflow.com/questions/8126802/when-testing-with-rspec-where-to-put-common-test-utility-methods
module PostHelpers
  def create_post(post_name, title, body, options={})
    piece_path = File.join(Everything::Blog::Source.absolute_path, post_name)
    piece = Everything::Piece.new(piece_path)

    FileUtils.mkdir_p(piece.full_path)

    File.open(piece.content.file_path, 'w') do |f|
      f.write("# #{title}\n\n#{body}")
    end

    metadata = {}.tap do |h|
      h['public'] = options['public'] || false
      h['created_at'] = options['created_at'] if options['created_at']
      h['wordpress'] = options['wordpress'] if options['wordpress']
    end

    File.open(piece.metadata.file_path, 'w') do |f|
      f.write(metadata.to_yaml)
    end
  end

  def delete_post(post_name)
    piece_path = File.join(Everything::Blog::Source.absolute_path, post_name)

    FileUtils.rm_rf(piece_path)
  end
end

