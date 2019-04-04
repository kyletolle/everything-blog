require 'pp' # helps prevent an error like: 'superclass mismatch for class file'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/remote/html_file'
require './lib/everything/blog/output/index'
require './spec/support/shared'
require 'time'

describe Everything::Blog::Remote::HtmlFile do
  # TODO: Add specs for these
  # include_context 'behaves like a Remote::FileBase'
  include_context 'with fake output index'
  include_context 'with mock fog'

  let(:html_file) do
    described_class.new(given_output_file)
  end
  let(:given_output_file) do
    fake_output_index
  end

  describe '::HTML_CONTENT_TYPE' do
    it 'is text/html' do
      expect(described_class::HTML_CONTENT_TYPE).to eq('text/html')
    end
  end

  describe '#initialize' do
    it 'sets the output_file to the given output file' do
      expect(html_file.output_file).to eq(given_output_file)
    end
  end

  describe '#content' do
    before do
      allow(given_output_file)
        .to receive(:output_content)
        .and_return("This content's completely fake and should not be trusted.")
    end

    it "is the output file's output_content" do
      expect(html_file.content).to eq(given_output_file.output_content)
    end
  end

  describe '#content_hash' do
    subject { html_file.content_hash }

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
        .with(html_file.content)
    end

    it 'returns the md5 hash'
  end

  describe '#content_type' do
    it 'is equal to HTML_CONTENT_TYPE' do
      expect(html_file.content_type).to eq(described_class::HTML_CONTENT_TYPE)
    end
  end

  describe '#local_file_is_different?' do
    subject { html_file.local_file_is_different? }

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
        include_context 'with fake output index'
        include_context 'with fake html file in s3'

        context 'and has a different hash than the current content' do
          before do
            allow(html_file)
              .to receive(:content_hash)
              .and_return(mock_html_file.etag.reverse)
          end

          it 'is true' do
            expect(subject).to eq(true)
          end
        end

        context 'and has the same hash as the current content' do
          before do
            allow(html_file)
              .to receive(:content_hash)
              .and_return(mock_html_file.etag)
          end

          it 'is false' do
            expect(subject).to eq(false)
          end
        end
      end
    end
  end

  describe '#send' do
    subject { html_file.send }

    context 'when the bucket does not exist' do
      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'when the bucket does exist' do
      include_context 'with mock bucket in s3'

      let(:s3_bucket) { Everything::Blog::S3Bucket.new }
      let(:actual_file) do
        s3_bucket
          .files
          .get(html_file.remote_key)
      end

      context 'when remote file does not exist' do
        # Note: Files from the list don't return all info that getting a
        # particular file will, as noted here:
        # https://stackoverflow.com/questions/17579118/set-content-type-of-fog-storage-files-on-s3#comment25803126_17657441
        # If we want to check the file's content_type, then we need to get that
        # file individually.
        let(:first_file) { s3_bucket.files.first }

        after do
          actual_file.destroy
        end

        it 'creates a file in the s3 bucket' do
          expect(s3_bucket.files).to be_empty
          subject
          expect(s3_bucket.files.reload).not_to be_empty
        end

        it 'creates the file with the right key' do
          subject

          expect(first_file.key).to eq(html_file.remote_key)
        end

        it 'creates the file with the right body' do
          subject

          expect(actual_file.body).to eq(html_file.content)
        end

        it 'creates the file with the right content_type' do
          subject

          expect(actual_file.content_type).to eq(html_file.content_type)
        end
      end

      context 'when the remote file does exist' do
        let(:midnight_utc) { Time.parse("2019-03-24 00:00:00 UTC") }
        let(:noon_utc) { Time.parse("2019-03-24 12:00:00 UTC") }
        before do
          Timecop.freeze(midnight_utc)

          mock_html_file
        end

        # Note: Include the fake file after faking the time.
        include_context 'with fake html file in s3'

        after do
          Timecop.return
        end

        context 'when the local file is the same' do
          before do
            allow(html_file)
              .to receive(:content)
              .and_return(mock_html_body)

            Timecop.freeze(noon_utc)
          end

          it "does not change the remote file's last modified time" do
            expect(actual_file.last_modified).to eq(midnight_utc)

            subject

            expect(actual_file.reload.last_modified).to eq(midnight_utc)
          end
        end

        context 'when the local file is different' do
          let(:updated_content) { mock_html_body.reverse }
          let(:modified_file) do
            s3_bucket
            .files
            .reload
            .get(html_file.remote_key)
          end

          before do
            allow(html_file)
              .to receive(:content)
              .and_return(updated_content)
            allow(html_file)
              .to receive(:local_file_is_different?)
              .and_return(true)

            Timecop.freeze(noon_utc)
          end

          it "changes the remote file's last modified time" do
            expect(actual_file.last_modified).to eq(midnight_utc)

            subject

            expect(modified_file.last_modified).to eq(noon_utc)
          end

          it "changes the remote file's body" do
            expect(actual_file.body).to eq(mock_html_body)

            subject

            expect(modified_file.body).to eq(updated_content)
          end
        end
      end
    end
  end

  describe '#remote_file' do
    subject { html_file.remote_file }

    context 'when the bucket does not exist' do
      it 'is nil' do
        expect(subject).to be_nil
      end
    end

    context 'when the bucket does exist' do
      include_context 'with mock bucket in s3'

      context 'when the remote file does not exist' do
        it 'is nil' do
          expect(subject).to be_nil
        end
      end

      context 'when the remote file exists' do
        include_context 'with fake output index'
        include_context 'with fake html file in s3'

        it 'returns an AWS file' do
          expect(subject).to be_a(Fog::AWS::Storage::File)
        end

        it 'returns a file with matching remote_key' do
          expect(subject.key).to eq(html_file.remote_key)
        end

        it 'calls head to get the file' do
          bucket_double = instance_double(Everything::Blog::S3Bucket)
          allow(html_file)
            .to receive(:s3_bucket)
            .and_return(bucket_double)
          files_double = instance_double(Fog::AWS::Storage::Files)
          allow(bucket_double)
            .to receive(:files)
            .and_return(files_double)
          allow(files_double)
            .to receive(:head)
          subject
          expect(files_double)
            .to have_received(:head)
            .with(html_file.remote_key)
        end
      end
    end
  end

  describe '#remote_file_does_not_exist?' do
    subject { html_file.remote_file_does_not_exist? }

    context 'when remote_file is nil' do
      before do
        allow(html_file)
          .to receive(:remote_file)
          .and_return(nil)
      end

      it 'is true' do
        expect(subject).to eq(true)
      end
    end

    context 'when remote_file is not nil' do
      include_context 'with fake html file in s3'

      before do
        allow(html_file)
          .to receive(:remote_file)
          .and_return(mock_html_file)
      end

      it 'is false' do
        expect(subject).to eq(false)
      end
    end
  end

  describe '#remote_key' do
    subject { html_file.remote_key }

    before do
      @initial_remote_key = subject.dup
      html_file.remote_key
      html_file.remote_key
      html_file.remote_key
    end

    it "is the output file's relative_file_path without the leading slash" do
      expected_file_key = given_output_file.output_file_name
      expect(subject).to eq(expected_file_key)
    end

    it 'returns the same result when called multiple times' do
      expect(html_file.remote_key).to eq(@initial_remote_key)
    end

    it 'memoizes the result' do
      expect(subject.object_id).to eq(html_file.remote_key.object_id)
    end
  end
end
