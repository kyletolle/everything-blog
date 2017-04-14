require 'pp'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/post'

describe Everything::Blog::Post do
  shared_context 'stub out everything path' do
    let(:fake_everything_path) do
      '/fake/everything/path'
    end

    before do
      allow(Everything).to receive(:path).and_return(fake_everything_path)
    end
  end

  shared_context 'with fake piece' do
    include_context 'stub out everything path'

    let(:piece_path) do
      File.join(Everything.path, given_post_name)
    end
    let(:fake_piece) do
      Everything::Piece.new(piece_path)
    end

    before do
      FakeFS.activate!

      FileUtils.mkdir_p(fake_piece.full_path)

      File.open(fake_piece.content.file_path, 'w') do |f|
        f.write("# Grond Crawled on\nOr so I was told.")
      end

      File.open(fake_piece.metadata.file_path, 'w') do |f|
        f.write("---\npublic: #{post_options[:public?] || false}")
      end
    end

    after do
      FileUtils.rm_rf(piece_path)

      FakeFS.deactivate!
    end
  end

  def delete_metadata_file(piece_name)
    FakeFS do
      piece_path = File.join(Everything.path, piece_name)
      fake_piece = Everything::Piece.new(piece_path)
      File.delete(fake_piece.metadata.file_path)
    end
  end

  let(:post) do
    described_class.new(given_post_name)
  end
  let(:fake_post_name) do
    'grond-crawled-on'
  end
  let(:given_post_name) do
    fake_post_name
  end
  let(:post_options) do
    {}
  end

  describe '#created_at' do
    include_context 'with fake piece'

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
        before do
          allow_any_instance_of(Everything::Piece::Metadata)
            .to receive(:[])
            .with('wordpress')
            .and_return(nil)
        end

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
    include_context 'with fake piece'

    let(:given_created_at) do
      1491886636
    end

    before do
      allow_any_instance_of(Everything::Piece::Metadata)
        .to receive(:[])
        .with('created_at')
        .and_return(given_created_at)
    end

    it 'is the human-friendly, American-style date' do
      expect(post.created_on).to eq('April 10, 2017')
    end
  end

  describe '#created_on_iso8601' do
    include_context 'with fake piece'

    let(:given_created_at) do
      1491886636
    end

    before do
      allow_any_instance_of(Everything::Piece::Metadata)
        .to receive(:[])
        .with('created_at')
        .and_return(given_created_at)
    end

    it 'is the ISO 8601 format date' do
      expect(post.created_on_iso8601).to eq('2017-04-10')
    end
  end

  describe '#public?' do
    include_context 'stub out everything path'

    context 'where there is no piece with that name' do
      it 'raises an error' do
        expect{post.public?}.to raise_error(ArgumentError)
      end
    end

    context 'where there is a piece with that name' do
      include_context 'with fake piece'

      context 'where the metadata file does not exist' do
        before do
          delete_metadata_file(given_post_name)
        end

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

  describe '#has_media?'
  describe '#media_paths'
  describe '#media_glob'

  describe '#piece' do
    context 'when the post is in the root directory' do
      include_context 'with fake piece'

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
      include_context 'with fake piece'

      let(:expected_nested_piece_path) do
        File.join(Everything.path, 'nested_dir', fake_post_name)
      end

      it 'finds the nested piece' do
        expect(post.piece.full_path).to eq(expected_nested_piece_path)
      end
    end
  end

  describe '#name'
  describe '#title'
  describe '#body'
end
