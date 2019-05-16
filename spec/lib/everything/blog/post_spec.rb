require 'pp'
require 'bundler/setup'
Bundler.require(:default)
require './spec/support/shared'
require './lib/everything/blog/post'

describe Everything::Blog::Post do
  let(:post) do
    described_class.new(given_post_name)
  end

  include_context 'with fake piece'

  describe '#body' do
    let(:expected_post_body) { fake_piece_body }

    it "is the piece's body" do
      expect(post.body).to eq(expected_post_body)
    end
  end

  describe '#created_at' do
    shared_examples 'raises a TypeError' do
      it 'raises an error' do
        expect { post.created_at }.to raise_error(TypeError)
      end
    end

    context 'when the piece metadata has the created_at key' do
      before do
        allow_any_instance_of(Everything::Piece::Metadata)
          .to receive(:[])
          .with('created_at')
          .and_return(given_created_at)
      end

      context 'with a value that is not a timestamp' do
        let(:given_created_at) do
          'not a timestamp'
        end

        include_examples 'raises a TypeError'
      end

      context 'with a value that is a timestamp' do
        let(:given_created_at) do
          1491886636
        end
        let(:expected_created_at) do
          Time.at(given_created_at)
        end

        it 'is the created_at timestamp' do
          expect(post.created_at).to eq(expected_created_at)
        end
      end
    end

    context 'when the piece metadata is missing the created_at key' do
      before do
        allow_any_instance_of(Everything::Piece::Metadata)
          .to receive(:[])
          .with('created_at')
          .and_return(nil)
      end

      context 'when the piece metadata is missing the wordpress key' do
        # before do
        #   allow_any_instance_of(Everything::Piece::Metadata)
        #     .to receive(:[])
        #     .with('wordpress')
        #     .and_return(nil)
        # end

        # We aren't going to handle this right now.
      end

      context 'when the piece metadata has the wordpress key' do
        let(:fake_wordpress_data) do
          {}
        end

        before do
          allow_any_instance_of(Everything::Piece::Metadata)
            .to receive(:[])
            .with('wordpress')
            .and_return(fake_wordpress_data)
        end

        context 'with a value that is missing the post_date key' do
          include_examples 'raises a TypeError'
        end

        context 'with a value that has the post_date key' do
          let(:fake_wordpress_data) do
            super().merge('post_date' => given_post_date)
          end

          context 'with a value that is not a timestamp' do
            let(:given_post_date) do
              'not a timestamp'
            end

            include_examples 'raises a TypeError'
          end

          context 'with a value that is a timestamp' do
            let(:given_post_date) do
              1491886636
            end
            let(:expected_created_at) do
              Time.at(given_post_date)
            end

            it 'is the created_at timestamp' do
              expect(post.created_at).to eq(expected_created_at)
            end
          end
        end
      end
    end
  end

  describe '#created_on' do
    let(:given_created_at) do
      1539644464
    end

    before do
      allow_any_instance_of(Everything::Piece::Metadata)
        .to receive(:[])
        .with('created_at')
        .and_return(given_created_at)
    end

    it 'is the human-friendly, American-style date' do
      expect(post.created_on).to eq('October 15, 2018')
    end
  end

  describe '#created_on_iso8601' do
    let(:given_created_at) do
      1539644464
    end

    before do
      allow_any_instance_of(Everything::Piece::Metadata)
        .to receive(:[])
        .with('created_at')
        .and_return(given_created_at)
    end

    it 'is the ISO 8601 format date' do
      expect(post.created_on_iso8601).to eq('2018-10-15')
    end
  end

  describe '#new_created_on' do
    let(:given_created_on) do
      Date.parse('2017-07-19')
    end

    before do
      allow_any_instance_of(Everything::Piece::Metadata)
        .to receive(:[])
        .with('created_on')
        .and_return(given_created_on)
    end

    it 'is the date where the string is ISO 8601 format' do
      expect(post.new_created_on.to_s).to eq('2017-07-19')
    end
  end

  describe '#new_created_on_human' do
    let(:given_created_on) do
      Date.parse('2017-07-19')
    end

    before do
      allow_any_instance_of(Everything::Piece::Metadata)
        .to receive(:[])
        .with('created_on')
        .and_return(given_created_on)
    end

    it 'is the human-friendly, American-style date' do
      expect(post.new_created_on_human).to eq('July 19, 2017')
    end
  end

  describe '#public?' do
    context 'where there is no piece with that name' do
      include_context 'with deleted piece'

      it 'raises an error' do
        expect{post.public?}.to raise_error(ArgumentError)
      end
    end

    context 'where there is a piece with that name' do
      context 'where the metadata file does not exist' do
        include_context 'with deleted metadata file'

        it 'is false' do
          expect(post.public?).to eq false
        end
      end

      context 'where the metadata file does exist' do
        context 'where the piece is not public' do
          before do
            allow_any_instance_of(Everything::Piece)
              .to receive(:public?)
              .and_return(false)
          end

          it 'is false' do
            expect(post.public?).to eq false
          end
        end

        context 'where the piece is public' do
          before do
            allow_any_instance_of(Everything::Piece)
              .to receive(:public?)
              .and_return(true)
          end

          it 'is true' do
            expect(post.public?).to eq true
          end
        end
      end
    end
  end

  describe '#has_media?' do
    context 'when there are no media paths' do
      before do
        allow(post)
          .to receive(:media_paths)
          .and_return([])
      end

      it 'is false' do
        expect(post.has_media?).to eq(false)
      end
    end

    context 'when there are media paths' do
      before do
        allow(post)
          .to receive(:media_paths)
          .and_return(['/some/fake/media.mp3'])
      end

      it 'is true' do
        expect(post.has_media?).to eq(true)
      end
    end
  end

  describe '#media_paths' do
    shared_context 'with fake file of type' do |file_type|
     let(:fake_file_path) do
       File.join(fake_piece.full_path, "fake_file.#{file_type}")
     end

      before do
        File.open(fake_file_path, 'w') do |f|
          f.write("This is a fake #{file_type}")
        end
      end
    end

    shared_examples 'includes piece media of type' do |file_type|
      include_context 'with fake file of type', file_type

      it "includes the piece's #{file_type}s" do
        expect(post.media_paths).to include(fake_file_path)
      end
    end

    context 'when the piece contains no media files' do
      it 'is an empty array' do
        expect(post.media_paths).to eq([])
      end
    end

    context 'when the piece contains media files' do
      include_examples 'includes piece media of type', 'jpg'
      include_examples 'includes piece media of type', 'png'
      include_examples 'includes piece media of type', 'gif'
      include_examples 'includes piece media of type', 'mp3'
    end

    context 'when the piece contains other non-media files' do
      include_context 'with fake file of type', 'txt'

      it 'does not include those non-media files' do
        expect(post.media_paths).not_to include(fake_file_path)
      end
    end
  end

  describe '#media_glob' do
    it "globs files in the piece's path" do
      expect(post.media_glob).to start_with(fake_piece.full_path)
    end

    shared_examples 'includes files of type' do |file_type|
      it "includes #{file_type} files" do
        expect(post.media_glob).to match(file_type)
      end
    end

    include_examples 'includes files of type', 'jpg'
    include_examples 'includes files of type', 'png'
    include_examples 'includes files of type', 'gif'
    include_examples 'includes files of type', 'mp3'
  end

  describe '#name' do
    it "is the piece's name" do
      expect(post.name).to eq(given_post_name)
    end
  end

  describe '#piece' do
    context 'when the post is in the root directory' do
      let(:expected_root_piece_path) do
        File.join(Everything.path, given_post_name)
      end

      it 'finds the root piece' do
        expect(post.piece.full_path).to eq(expected_root_piece_path)
      end
    end

    context 'when the post is in a nested directory' do
      let(:given_post_name) do
        File.join('nested_dir', fake_post_name)
      end

      let(:expected_nested_piece_path) do
        File.join(Everything.path, 'nested_dir', fake_post_name)
      end

      it 'finds the nested piece' do
        expect(post.piece.full_path).to eq(expected_nested_piece_path)
      end
    end
  end

  describe '#title' do
    let(:expected_post_title) { fake_piece_title }

    it "is the piece's title" do
      expect(post.title).to eq(expected_post_title)
    end
  end
end
