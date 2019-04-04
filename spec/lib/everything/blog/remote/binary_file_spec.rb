require 'pp' # helps prevent an error like: 'superclass mismatch for class file'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/remote/binary_file'
require './lib/everything/blog/output/media'
require './spec/support/shared'

describe Everything::Blog::Remote::BinaryFile do
  include_context 'with fake output media'
  include_context 'with mock fog'

  let(:binary_file) do
    described_class.new(given_output_file)
  end
  let(:given_output_file) do
    fake_output_media
  end

  describe '#initialize' do
    it 'sets the output_file to the given output file' do
      expect(binary_file.output_file).to eq(given_output_file)
    end
  end

  describe '#content' do
    before do
      allow(given_output_file)
        .to receive(:output_content)
        .and_return("This content's completely fake and should not be trusted.")
    end

    it "is the output file's output_content" do
      expect(binary_file.content).to eq(given_output_file.output_content)
    end
  end

  describe '#content_hash' do
    subject { binary_file.content_hash }

    let(:md5_double) { instance_double(Digest::MD5) }

    before do
      allow(Digest::MD5)
        .to receive(:new)
        .and_return(md5_double)
      allow(md5_double)
        .to receive(:hexdigest)
    end

    it 'uses the md5 library to do a hexdigest' do
      subject

      expect(md5_double)
        .to have_received(:hexdigest)
        .with(binary_file.content)
    end

    it 'returns the md5 hash' do
      fake_hash = 'defn0tah4sh'

      allow(md5_double)
        .to receive(:hexdigest)
        .and_return(fake_hash)
      expect(subject).to eq(fake_hash)
    end
  end

  describe '#content_type' do
    it "is equal to the output file's content_type" do
      expect(binary_file.content_type).to eq(given_output_file.content_type)
    end
  end

  describe '#local_file_is_different?' do
    subject { binary_file.local_file_is_different? }

    context 'when the bucket does not exist' do
      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'when the bucket does exist' do
      include_context 'with mock bucket in s3'

      context 'when remote file does not exist' do
        it 'is true' do
          expect(subject).to eq(true)
        end
      end

      context 'when remote file does exist' do
        include_context 'with fake binary file in s3'

        context 'and has a different hash than the current content' do
          before do
            allow(binary_file)
              .to receive(:content_hash)
              .and_return(mock_binary_file.etag.reverse)
          end

          it 'is true' do
            expect(subject).to eq(true)
          end
        end

        context 'and has the same hash as the current content' do
          before do
            allow(binary_file)
              .to receive(:content_hash)
              .and_return(mock_binary_file.etag)
          end

          it 'is false' do
            expect(subject).to eq(false)
          end
        end
      end
    end
  end

  describe '#send'
end

