require 'spec_helper'
require './spec/support/post_helpers'

describe Everything::Blog::Output::Site do
  include_context 'stub out everything path'
  include_context 'with fake blog path'
  include_context 'with public posts'

  let(:output_site) do
    described_class.new(given_source_files)
  end
  let(:given_source_files) do
    source_site.files
  end
  let(:source_site) do
    Everything::Blog::Source::Site.new
  end

  describe '#initialize' do
    it 'takes a source_files argument' do
      expect{ described_class.new(given_source_files) }
        .not_to raise_error
    end
  end

  describe '#generate' do
    include_context 'with an index template'

    it 'asks each output file if it should generate output'

    context 'when no files should generate output' do
      # before do
      #   allow_any_instance_of(Everything::Blog::Output::Page)
      #     .to receive(:should_generate_output?)
      #     .and_return(false)
      # end

      xit 'does not save any files'
      # xit 'does not save any files' do
        # expect_any_instance_of(Everything::Blog::Output::Page)
        #   .not_to receive(:save_file)

        # output_site.generate
      # end
    end

    context 'when some files should generate output' do
      it 'calls save_file on each file that should generate output'
      it 'does not call save_file on each file that should not generate output'
    end
  end

  describe '#output_files' do
    it 'creates an output file for each source file' do
      output_site.output_files.each do |output_file|
        expect(output_file).to be_kind_of(Everything::Blog::Output::FileBase)
      end
    end
  end
end
