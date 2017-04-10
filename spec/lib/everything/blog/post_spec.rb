require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/post'

describe Everything::Blog::Post do
  let(:post) do
    described_class.new(given_post_name)
  end
  let(:given_post_name) do
    'grond-crawled-on'
  end

  shared_context 'stub out everything path' do
    let(:fake_everything_path) do
      '/fake/everything/path'
    end

    before do
      allow(Everything).to receive(:path).and_return(fake_everything_path)
    end
  end

  def create_piece(piece_name, options={})
    FakeFS do
      piece_path = File.join(Everything.path, piece_name)
      fake_piece = Everything::Piece.new(piece_path)
      FileUtils.mkdir_p(fake_piece.full_path)

      File.open(fake_piece.content.file_path, 'w') do |f|
        f.write("# Grond Crawled on\nOr so I was told.")
      end

      File.open(fake_piece.metadata.file_path, 'w') do |f|
        f.write("---\npublic: #{options[:public?] || false}")
      end
    end
  end

  def delete_piece(piece_name)
    FakeFS do
      piece_path = File.join(Everything.path, piece_name)
      FileUtils.rm_rf(piece_path)
    end
  end

  def delete_metadata_file(piece_name)
    FakeFS do
      piece_path = File.join(Everything.path, piece_name)
      fake_piece = Everything::Piece.new(piece_path)
      File.delete(fake_piece.metadata.file_path)
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
      before do
        create_piece(given_post_name)
      end

      after do
        delete_piece(given_post_name)
      end

      context 'where the metadata file does not exist' do
        before do
          delete_metadata_file(given_post_name)
        end

        it 'is false' do
          FakeFS do
            expect(post.public?).to eq false
          end
        end
      end

      context 'where the metadata file does exist' do
        context 'where the piece is not public' do
          before do
            allow_any_instance_of(Everything::Piece).to receive(:public?).and_return(false)
          end

          it 'is false' do
            FakeFS do
              expect(post.public?).to eq false
            end
          end
        end

        context 'where the piece is public' do
          before do
            allow_any_instance_of(Everything::Piece).to receive(:public?).and_return(true)
          end

          it 'is true' do
            FakeFS do
              expect(post.public?).to eq true
            end
          end
        end
      end
    end
  end

  describe '#has_media?'
  describe '#media_paths'
  describe '#piece'
  describe '#created_on'
  describe '#created_on_iso8601'
  describe '#piece'
  describe '#name'
  describe '#title'
  describe '#body'
end
